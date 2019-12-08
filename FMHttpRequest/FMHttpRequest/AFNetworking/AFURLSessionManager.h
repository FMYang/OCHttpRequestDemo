
#import <Foundation/Foundation.h>

#import "AFURLResponseSerialization.h"
#import "AFURLRequestSerialization.h"
#import "AFSecurityPolicy.h"
#import "AFCompatibilityMacros.h"
#if !TARGET_OS_WATCH
#import "AFNetworkReachabilityManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// AFURLSessionManager类
@interface AFURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSSecureCoding, NSCopying>

/// NSURLSession实例
@property (readonly, nonatomic, strong) NSURLSession *session;

/// 代理运行和回调的队列
@property (readonly, nonatomic, strong) NSOperationQueue *operationQueue;

/// 响应序列化对象
@property (nonatomic, strong) id <AFURLResponseSerialization> responseSerializer;

/// 安全策略
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

#if !TARGET_OS_WATCH
/// 网络监听
@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
#endif

/// 当前session运行的所有task集合
@property (readonly, nonatomic, strong) NSArray <NSURLSessionTask *> *tasks;

/// 当前运行的data tasks
@property (readonly, nonatomic, strong) NSArray <NSURLSessionDataTask *> *dataTasks;

/// 当前运行的upload tasks
@property (readonly, nonatomic, strong) NSArray <NSURLSessionUploadTask *> *uploadTasks;

/// 当前运行的download tasks
@property (readonly, nonatomic, strong) NSArray <NSURLSessionDownloadTask *> *downloadTasks;

///-------------------------------
/// @name Managing Callback Queues
///-------------------------------

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
/// completionBlock所在的队列，如果为NULL，默认在主线程调用
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

/// completionBlock派发组，如果为NULL，默认使用私有派发组
@property (nonatomic, strong, nullable) dispatch_group_t completionGroup;

///---------------------------------
/// @name Working Around System Bugs
///---------------------------------
///
/// bugfix
@property (nonatomic, assign) BOOL attemptsToRecreateUploadTasksForBackgroundSessions;

///---------------------
/// @name Initialization
///---------------------

/// 通过指定的配置创建AFURLSessionManager
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/// 一般不用
- (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks DEPRECATED_ATTRIBUTE;
- (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks resetSession:(BOOL)resetSession;

///-------------------------
/// @name Running Data Tasks
///-------------------------

/// 通过指定的request创建NSURLSessionDataTask
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler DEPRECATED_ATTRIBUTE;

/// 通过指定的request创建NSURLSessionDataTask
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

///---------------------------
/// @name Running Upload Tasks
///---------------------------

/// 上传
/// 通过指定的request创建NSURLSessionUploadTask，上传本地文件
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError  * _Nullable error))completionHandler;

/// 通过指定的request创建NSURLSessionUploadTask，上传NSData文件
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(nullable NSData *)bodyData
                                         progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// 通过指定的StreamedRequest创建NSURLSessionUploadTask
- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
                                        completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// 下载
/// 通过指定的request创建NSURLSessionDownloadTask
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

///---------------------------------
/// @name Getting Progress for Tasks
///---------------------------------

/// 获取上传进度
- (nullable NSProgress *)uploadProgressForTask:(NSURLSessionTask *)task;

/// 获取下载进度
- (nullable NSProgress *)downloadProgressForTask:(NSURLSessionTask *)task;

///-----------------------------------------
/// @name Setting Session Delegate Callbacks
///-----------------------------------------

/// 设置session无效的回调块
- (void)setSessionDidBecomeInvalidBlock:(nullable void (^)(NSURLSession *session, NSError *error))block;

/// 设置证书挑战触发回调块
- (void)setSessionDidReceiveAuthenticationChallengeBlock:(nullable NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential))block;

/// 设置回调块
- (void)setTaskNeedNewBodyStreamBlock:(nullable NSInputStream * (^)(NSURLSession *session, NSURLSessionTask *task))block;

/// 设置回调块
- (void)setTaskWillPerformHTTPRedirectionBlock:(nullable NSURLRequest * _Nullable (^)(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request))block;

/// 设置回调块
- (void)setTaskDidReceiveAuthenticationChallengeBlock:(nullable NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential))block;

/// 设置回调块
- (void)setTaskDidSendBodyDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))block;

/// 设置回调块
- (void)setTaskDidCompleteBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSError * _Nullable error))block;

/// 设置回调块
#if AF_CAN_INCLUDE_SESSION_TASK_METRICS
- (void)setTaskDidFinishCollectingMetricsBlock:(nullable void (^)(NSURLSession *session, NSURLSessionTask *task, NSURLSessionTaskMetrics * _Nullable metrics))block;
#endif
///-------------------------------------------
/// @name Setting Data Task Delegate Callbacks
///-------------------------------------------

/// 设置回调块
- (void)setDataTaskDidReceiveResponseBlock:(nullable NSURLSessionResponseDisposition (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLResponse *response))block;

/// 设置回调块
- (void)setDataTaskDidBecomeDownloadTaskBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSURLSessionDownloadTask *downloadTask))block;

/// 设置回调块
- (void)setDataTaskDidReceiveDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data))block;

/// 设置回调块
- (void)setDataTaskWillCacheResponseBlock:(nullable NSCachedURLResponse * (^)(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse))block;

/// 设置回调块
- (void)setDidFinishEventsForBackgroundURLSessionBlock:(nullable void (^)(NSURLSession *session))block AF_API_UNAVAILABLE(macos);

///-----------------------------------------------
/// @name Setting Download Task Delegate Callbacks
///-----------------------------------------------

/// 设置回调块
- (void)setDownloadTaskDidFinishDownloadingBlock:(nullable NSURL * _Nullable  (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location))block;

/// 设置回调块
- (void)setDownloadTaskDidWriteDataBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite))block;

/// 设置回调块
- (void)setDownloadTaskDidResumeBlock:(nullable void (^)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t fileOffset, int64_t expectedTotalBytes))block;

@end

///--------------------
/// @name Notifications
///--------------------

// 通知task resumes
/**
 Posted when a task resumes.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidResumeNotification;

/**
 Posted when a task finishes executing. Includes a userInfo dictionary with additional information about the task.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteNotification;

/**
 Posted when a task suspends its execution.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidSuspendNotification;

/**
 Posted when a session is invalidated.
 */
FOUNDATION_EXPORT NSString * const AFURLSessionDidInvalidateNotification;

/**
 Posted when a session download task encountered an error when moving the temporary download file to a specified destination.
 */
FOUNDATION_EXPORT NSString * const AFURLSessionDownloadTaskDidFailToMoveFileNotification;

/**
 The raw response data of the task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if response data exists for the task.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseDataKey;

/**
 The serialized response object of the task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if the response was serialized.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSerializedResponseKey;

/**
 The response serializer used to serialize the response. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if the task has an associated response serializer.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteResponseSerializerKey;

/**
 The file path associated with the download task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if an the response data has been stored directly to disk.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteAssetPathKey;

/**
 Any error associated with the task, or the serialization of the response. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteNotification` if an error exists.
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteErrorKey;

/**
 The session task metrics taken from the download task. Included in the userInfo dictionary of the `AFNetworkingTaskDidCompleteSessionTaskMetrics`
 */
FOUNDATION_EXPORT NSString * const AFNetworkingTaskDidCompleteSessionTaskMetrics;

NS_ASSUME_NONNULL_END
