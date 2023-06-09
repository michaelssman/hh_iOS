//
//  HHFMDBTool.m
//  MyFMDB
//
//  Created by 崔辉辉 on 2018/7/20.
//  Copyright © 2018年 michael. All rights reserved.
//

#import "HHFMDBTool.h"
#import "HHFMDBUtil.h"
#import "HHFMDBMacros.h"
@interface HHFMDBTool()
@property (nonatomic, strong)NSMutableDictionary *storageTypeDic;
@end

@implementation HHFMDBTool
- (NSMutableDictionary *)storageTypeDic {
    if (!_storageTypeDic) {
        self.storageTypeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _storageTypeDic;
}

+ (nonnull instancetype)sharedTool {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [HHFMDBTool defaultDatabase];
    }
    return self;
}
#pragma mark 创建数据库
+ (FMDatabase *)defaultDatabase {
   return [HHFMDBTool databaseWithName:kDataBaseName];
}
+ (FMDatabase *)databaseWithName:(NSString *)dbName {
    NSString *dbPath = [HHFMDBUtil dbPathForName:dbName];
    
    //如果文件创建不成功，可能是路径不存在，需要手动创建路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:nil];
    }
    FMDatabase *fmdb = [FMDatabase databaseWithPath:dbPath];
    BOOL openSuccess = [fmdb open];
    if (openSuccess) {
        NSLog(@"数据库打开成功");
    } else {
        NSLog(@"数据库打开失败");
    }
    return fmdb;
}
+ (FMDatabaseQueue *)defaultDatabaseQueue {
    return [HHFMDBTool databaseQueueWithName:kDataBaseName];
}
+ (FMDatabaseQueue *)databaseQueueWithName:(NSString *)dbName {
    NSString *dbPath = [HHFMDBUtil dbPathForName:dbName];
    
    //如果文件创建不成功，可能是路径不存在，需要手动创建路径
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:dbPath contents:nil attributes:nil];
    }
    
    return [[FMDatabaseQueue alloc]initWithPath:dbPath];
}

#pragma mark 创建表
- (BOOL)createTableWithTableName:(NSString *)tableName
                      dicOrModel:(id)parameters
                     excludeName:(NSArray * _Nullable)nameArr
                              db:(FMDatabase *)db {
    return [self createTableWithTableName:tableName dicOrModel:parameters excludeName:nameArr db:db primaryKeyDic:nil];
}
- (BOOL)createTableWithTableName:(NSString *)tableName
                      dicOrModel:(id)parameters
                     excludeName:(NSArray * _Nullable)nameArr
                              db:(FMDatabase * _Nonnull)db
                   primaryKeyDic:(NSDictionary * _Nullable)primaryKeyDic
{
    BOOL result = NO;
    
    NSDictionary *dic = [HHFMDBUtil storageTypeTodictionary:parameters];
    
    NSMutableDictionary *dbDic = [NSMutableDictionary dictionaryWithDictionary:[self.storageTypeDic valueForKey:[HHFMDBUtil getFileName:db.databasePath]]];
    [dbDic setObject:dic forKey:tableName];
    
    [self.storageTypeDic setValue:dbDic forKey:[HHFMDBUtil getFileName:db.databasePath]];
    
    NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName];

    //把模型中不保存的属性去除
    int keyCount = 0;
    for (NSString *key in dic) {
        keyCount++;
        if (primaryKeyDic && [key isEqualToString:primaryKeyDic[kPrimaryKeyName]]) {
            //最后一个 没有最后的逗号
            if (keyCount == dic.count) {
                [sql appendFormat:@"%@ %@ PRIMARY KEY)",primaryKeyDic[kPrimaryKeyName],primaryKeyDic[kPrimaryKeyType]];
                break;
            } else {
                [sql appendFormat:@"%@ %@ PRIMARY KEY,",primaryKeyDic[kPrimaryKeyName],primaryKeyDic[kPrimaryKeyType]];
                continue;
            }
        }
        //不需要保存的字段
        if (nameArr && [nameArr containsObject:key]) {
            if (keyCount == dic.count) {
                [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
                [sql appendFormat:@")"];
                break;
            }
            continue;
        }
        if (keyCount == dic.count) {
            [sql appendFormat:@" %@ %@)",key,dic[key]];
            break;
        }
        [sql appendFormat:@" %@ %@,",key,dic[key]];
    }
    
    result = [db executeUpdate:sql];

    return result;
}
#pragma mark 得到表里面字段的名称
- (NSArray *)getColumnArr:(NSString *)tableName
                       db:(FMDatabase * _Nonnull)db
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *resultSet = [db getTableSchema:[NSString stringWithFormat:@"%@",tableName]];
    while ([resultSet next]) {
        [arr addObject:[resultSet stringForColumn:@"name"]];
    }
    return arr;
}

#pragma mark useTransaction
+ (void)hh_useTransaction:(FMDatabase * _Nonnull)db
                    block:(void (^)(void))block
{
    FMDatabase *fmdb;
    if ([fmdb beginTransaction]) {
        BOOL isRollBack = NO;
        @try
        {
            //这里面写增删改查操作 for循环 多个操作
            block();
        }
        @catch (NSException *exception)
        {
            isRollBack = YES;
            [fmdb rollback];
        }
        @finally
        {
            if (!isRollBack)
            {
                [fmdb commit];
            }
        }
    }
}

#pragma mark ---------增---------
- (void)insertWithTableName:(NSString *)tableName
                 dataSource:(id)dataSource
                         db:(FMDatabase * _Nonnull)db
{

    NSArray *columnArr = [self getColumnArr:tableName db:db];
    NSDictionary *propertyTypeDic = [self.storageTypeDic valueForKey:[HHFMDBUtil getFileName:db.databasePath]][tableName];
    //多条数据
    if ([dataSource isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < [dataSource count]; i++) {
            [self insertWithTableName:tableName dataSource:dataSource[i] columnArr:columnArr propertyTypeDic:propertyTypeDic db:db];
        }
    }
    //一条数据
    else {
        [self insertWithTableName:tableName dataSource:dataSource columnArr:columnArr propertyTypeDic:propertyTypeDic db:db];
    }
}
#pragma mark 插入单条数据
- (BOOL)insertWithTableName:(NSString *)tableName
                 dataSource:(id)dataSource
                  columnArr:(NSArray *)columnArr
            propertyTypeDic:(NSDictionary *)propertyTypeDic
                         db:(FMDatabase * _Nonnull)db
{
    
    NSDictionary *dic;
    if ([dataSource isKindOfClass:[NSDictionary class]]) {
        dic = dataSource;
    } else {
        dic = [HHFMDBUtil getModelPropertyKeyValue:dataSource clomnArr:columnArr];
    }

    NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"INSERT INTO %@ (",tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        if (![columnArr containsObject:key]) {
            continue;
        }
        [sql appendFormat:@"%@,",key];
        [tempStr appendString:@"?,"];
        
        if ([propertyTypeDic[key] isEqualToString:SQL_ARRAY]) {//数组存储前先反序列化为二进制数据
            [argumentsArr addObject:[NSKeyedArchiver archivedDataWithRootObject:dic[key]]];
        }else if([propertyTypeDic[key] isEqualToString:SQL_MODEL]){//模型存储前先反序列化为二进制数据
            [argumentsArr addObject:[NSKeyedArchiver archivedDataWithRootObject:dic[key]]];
        }else {
            [argumentsArr addObject:dic[key]];
        }
        
    }
    
    //删除最后一个符号
    [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];
    //删除最后一个符号
    if (tempStr.length) {
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length - 1, 1)];
    }
    
    [sql appendFormat:@") VALUES (%@)",tempStr];
    
    return [db executeUpdate:sql withArgumentsInArray:argumentsArr];
}

#pragma mark ---------删---------
- (BOOL)deleteDatabase:(FMDatabase * _Nonnull)db Table:(NSString *)tableName whereFormat:(NSString *)whereFormat
{
    BOOL result = NO;
    NSMutableString *sqlString = [[NSMutableString alloc]initWithFormat:@"DELETE FROM %@ WHERE %@",tableName,whereFormat];
    return [db executeUpdate:sqlString];
}

#pragma mark ---------改---------
- (BOOL)updateDatabase:(FMDatabase * _Nonnull)db
                 Table:(NSString *)tableName
            dataSource:(id)dataSource
           whereFormat:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION
{
    BOOL result = NO;
    NSMutableString *sqlString;
    NSMutableString *whereString;

    va_list args;
    va_start(args, format);
    if (format) {
        //输出第一个字符串
        NSString *where;
        where = format ? [[NSString alloc]initWithFormat:format locale:[NSLocale currentLocale] arguments:args] : format;
        whereString = [[NSMutableString alloc]initWithFormat:@"%@",where];
        
        sqlString = [[NSMutableString alloc]initWithFormat:@"UPDATE %@ SET ",tableName];

        NSDictionary *dic;
        NSArray *clomnArr = [self getColumnArr:tableName db:db];
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            dic = dataSource;
        } else {
            dic = [HHFMDBUtil getModelPropertyKeyValue:dataSource clomnArr:clomnArr];
        }
        
        NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *key in dic) {
            if (![clomnArr containsObject:key]) {
                continue;
            }
            [sqlString appendFormat:@"%@ = %@,",key,@"?"];
            [argumentsArr addObject:dic[key]];
        }
        
        [sqlString deleteCharactersInRange:NSMakeRange(sqlString.length - 1, 1)];
        
        while (1) {
            //依次取得所有参数
            where = va_arg(args, NSString*);
            if (where == nil) {
                break;
            }
            else {
                where = [[NSString alloc]initWithFormat:where locale:nil arguments:args];
                [whereString appendString:where];
            }
        }
        

        if (whereString.length) {
            [sqlString appendFormat:@" WHERE %@",whereString];
        }
        
        result = [db executeUpdate:sqlString withArgumentsInArray:argumentsArr];
    }
    va_end(args);
    
    return result;
}

#pragma mark 查
- (NSArray *)selectDatabase:(FMDatabase * _Nonnull)db
                      table:(NSString *)tableName
                 dicOrModel:(id)parameters
                whereFormat:(NSString * _Nullable)format
{
    NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"SELECT * FROM %@ %@",tableName, format ? [@" WHERE " stringByAppendingString:format] : @""];
    
    FMResultSet *set = [db executeQuery:sql];
    
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *propertyType = [NSDictionary dictionary];
    NSArray *clomnArr = [NSArray array];
    Class CLS;
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        CLS = [NSMutableDictionary class];
        //查找结果 转为字典
        propertyType = parameters;
        clomnArr = propertyType.allKeys;
    }
    else {
        CLS = [HHFMDBUtil getModelClass:parameters];
        propertyType = [self.storageTypeDic valueForKey:[HHFMDBUtil getFileName:db.databasePath]][tableName];
        clomnArr = [self getColumnArr:tableName db:db];
    }
    
    if (CLS) {
        while ([set next]) {
            id resultObj = CLS.new;
            
            for (NSString *name in clomnArr) {
                if ([propertyType[name] isEqualToString:SQL_TEXT]) {
                    id value = [set stringForColumn:name];
                    if (value) {
                        [resultObj setValue:value forKey:name];
                    }
                } else if ([propertyType[name] isEqualToString:SQL_INTEGER]) {
                    [resultObj setValue:@([set longLongIntForColumn:name]) forKey:name];
                } else if ([propertyType[name] isEqualToString:SQL_REAL]) {
                    [resultObj setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                } else if ([propertyType[name] isEqualToString:SQL_BLOB]) {
                    id value = [set dataForColumn:name];
                    if (value) {
                        [resultObj setValue:value forKey:name];
                    }
                } else if ([propertyType[name] isEqualToString:SQL_ARRAY]) {
                    NSData *data = [set dataForColumn:name];
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [resultObj setValue:array forKey:name];
                } else if ([propertyType[name] isEqualToString:SQL_MODEL]) {
                    NSData *data = [set dataForColumn:name];
                    id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    [resultObj setValue:model forKey:name];
                }
            }
            
            if (resultObj) {
                [resultArr addObject:resultObj];
            }
        }
    }
    
    return resultArr;
}

#pragma mark 清空表
- (BOOL)deleteAllDataFromTable:(NSString *)tableName
                            db:(FMDatabase * _Nonnull)db
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    return [db executeUpdate:sqlstr];
}

#pragma mark - 数据库中表是否存在
- (BOOL)hasTable:(NSString *)tableName
              db:(FMDatabase * _Nonnull)db
{
    NSString *sql = [NSString stringWithFormat:@"select count(name) as 'count' from sqlite_master where type ='table' and name = %@", tableName];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        return count == 0 ? NO : YES;
    }
    return NO;
}
@end
