/*
 *  crossshared.h
 *  LionRss
 *
 *  Created by NicholasXu on 11-5-17.
 *  Copyright 2011 DehengXu. All rights reserved.
 *
 */

#pragma mark - 系统字体常量 尺寸，字体名等

//FONT SIZE & STYLE
//@"Helvetica-Bold"
//@"TimesNewRomanPS-BoldMT"
//[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
#define FONT_SIZE_BIG	14
#define FONT_SIZE_MEDIA 12
#define FONT_SIZE_SMALL	10
#define FONT_SIZE_TINY	8

//Font Size
#define FONT_SIZE_BOOK_NAME             28
#define FONT_SIZE_BOOK_DESCRIPTION      21
#define FONT_SIZE_NAV_TITLE             31
#define FONT_SIZT_TAB_TITLE             32
#define FONT_SIZE_REFRESH               20

//Font Color
#define FONT_COLOR_NAV_TITLE            [UIColor colorWithRed:(186 / 255.0) green:(186 / 255.0) blue:(186 / 255.0) alpha:1.0]
#define FONT_COLOR_TAB_TITLE            [UIColor colorWithRed:(186 / 255.0) green:(186 / 255.0) blue:(186 / 255.0) alpha:1.0]
#define FONT_COLOR_REFRESH_TEXT			[UIColor colorWithRed:(141 / 255.0) green:(141 / 255.0) blue:(141 / 255.0) alpha:1.0]
#define FONT_COLOR_MORE_CELL_INFO		[UIColor colorWithRed:64 / 255.0 green:120 / 255.0 blue:200 / 255.0 alpha:1.0]
#define FONT_COLOR_MORE_CELL_TITLE		[UIColor colorWithRed:88 / 255.0 green:89 / 255.0 blue: 91 / 255.0 alpha:1.0]

//Text Const
#define DEFAULT_COMMENT_TEXT @"请输入书评内容（120字以内）"
#define LIMIT_NUMBER_FOR_INPUTCOMMENT   120

#pragma mark - 自定义标签ID
//Todo 添加自定义标签ID

#pragma mark - D.E.B.U.G.E.R
//Todo 添加自定义的调试宏
//============================= D.E.B.U.G.E.R ======================
//初始化调试
#define INIT_LOGGING    0
//释放内存调试
#define DEALLOC_LOGING  0
//调试网络数据压缩信息
#define DEBUG_COMPRESSED_DATA_LOGGING   0
#define DEBUG_FAVORITE_BLANK_BIND       1
#define TAG_STARTING    @"+++++++++++++++++"
#define TAG_ENDING      @"-----------------"
#define MAKE_MEMORY_POOL   [NSAutoreleasePool new]

//add macro RELEASE_VERSION INTO preprocessor MACROS
#ifdef DISTRIB_VERSION
#define NSLog(...)  
#endif


#define NETWORK_FORBIDDEN   0

#define SafeRelease(obj) [obj release]; obj = nil;
#define ObjectByAddr(addr) (*addr)

#pragma mark - 系统操作提示文字
#define ADD_HISTORY_FAILED_INFO @"添加历史失败"


#pragma mark - 接口状态码 及 返回消息文字
#define SUCCESS_OPERATION					100
#define FAILED_OPERATION					101
#define PARAM_ERROR							102
#define REGISTER_ACCOUNT_EXISTED			103
#define BOOK_OFFSHELF						104
#define FAVORITE_ADD_REPEAT					105
#define FOLDER_ADD_LIMIT					106
#define SURRPASSES_WORDS_COUNT_LIMIT		107
#define TEXT_IS_NULL						108
#define TADU_REGISTER_FAILED				109
#define TADU_LOGIN_SUCCESS					110
#define REGISTER_EXIST						111
#define LOGIN_FAILED						113
#define TADU_REGISTER_SUCCESS				114
#define UNKNOW_CLIENT						115
#define PASSWORD_WRONG						116
#define MULT_INPUT_PWD_WRONG				117
#define NO_UPDATE							118
#define SHARE_TADU_FAILED                   127
#define SHARE_SINA_FAILED                   128
#define LOG_BACKUP_FAILED					129
#define SERVICE_DEFINE                      500
#define SHARE_VERIFYSINA_FAILED             501

#define SUCCESS_OPERATION_MESSAGE				@"操作成功!"
#define PARAM_ERROR_MESSAGE						@"参数错误!"
#define REGISTER_ACCOUNT_EXISTED_MESSAGE		@"注册信息已经存在!"
#define BOOK_OFFSHELF_MESSAGE					@"该书已下架，是否删除本书!"
#define FAVORITE_ADD_REPEAT_MESSAGE				@"该书已被收藏，无需再次操作!"
#define FOLDER_ADD_LIMIT_MESSAGE				@"文件创建达到最大数量!"
#define SURRPASSES_WORDS_COUNT_LIMIT_MESSAGE	@"发送字数超出限制!"
#define	TEXT_IS_NULL_MESSAGE					@"发送信息为空!"
#define TADU_REGISTER_FAILED_MESSAGE			@"注册失败!"
#define TADU_LOGIN_SUCCESS_MESSAGE				@"塔读账户登录成功!"
#define REGISTER_EXIST_MESSAGE					@"塔读账户已存在，请重新注册!"
#define LOGIN_FAILED_MESSAGE					@"账户登录不成功，账号或者密码错误!"
#define TADU_REGISTER_SUCCESS_MESSAGE			@"您已经注册成功!"
#define UNKNOW_CLIENT_MESSAGE					@"未知客户端!"
#define PASSWORD_WRONG_MESSAGE					@"原始密码不正确!"
#define MULT_INPUT_PWD_WRONG_MESSAGE			@"密码修改失败！您今天尝试次数已达3此!"
#define NO_UPDATE_MESSAGE						@"你使用的版本已为最新版本!"
#define SOFT_UPDATE_MESSAGE						@"发现新版本，是否更新?"
#define LOG_BACKUP_FAILED_MESSAGE				@"离线日志上传失败!"
#define SHARE_TADU_FAILED_MESSAGE               @"分享失败!"
#define SHARE_SINA_FAILED_MESSAGE               @"新浪分享失败!"
#define SHARE_BOTH_SUCCESS_MESSAGE              @"分享成功!"


#define TIPS_NET_FAILED_MSG @"网络连接失败！"
#define TIPS_NET_FAILED_MSG_RETRY @"网络连接失败，请检查网络状态后重试！"
#define TIPS_WAITING4_ADD2FAVORITE_MSG  @"正在收藏,请稍候..."
#define TIPS_ADD2FAVORITE_SUCCESS_MSG   @"收藏成功!"
#define TIPS_EXIST_FAVORITE_MSG         @"已经添加过!"
#define TIPS_WAITING4_READING_MSG       @"正在读取,请稍候..."
#define TIPS_CHAPTER_UPDATED_MSG        @"本书已有新章节!"
#define TIPS_PWD_LESSTHAN_LENGTH_6      @"密码长度不能小于6位!"
#define TIPS_PWD_USERNAME_CANNOTBE_EMPTY      @"用户名或密码不能为空!"
#define TIPS_PWD_CONTAINS_ILLEGAL_CHAR        @"密码不可有特殊字符!"
#define TIPS_COMMENTS_FINISHED  @"发布成功!"
#define TIPS_COMMENTS_SENDING   @"正在提交，请稍候..."
#define TIPS_FEEDBACK_MESSAGE	@"提交成功，感谢您的反馈!"
#define TIPS_LATEST_CHAPTER   @"本章已是最新!"
#define TIPS_LAST_CHAPTER   @"最后一章!"
#define BOOK_OFFSHELF_MSG   @"书籍已经下架!"
#define TITLE_FOR_LOOKCOMMENTS(number)  [NSString stringWithFormat:@"评论(共%d条书评)", number]
#define TITLE_FOR_DIRECTORIES(number)  [NSString stringWithFormat:@"目录(共%d个章节)", number]
#define DEFAULT_COVER_FAVORITE	@"暂无封面.png"
#define DEFAULT_COVER_HISTORY	@"历史页书封.png"

//查看目录和查看书评
#define TAG_BUTTON_PREVIOUS     100
#define TAG_BUTTON_NEXT         101
#define TAG_TEXTFIELD_JUMPTO    102
#define TAG_LABEL_TOTALPAGES    103
#define TAG_BUTTON_JUMP         104
#define TAG_BUTTON_LAST         105

//微提示
#define TAG_NOHISTORY_BK    1000
#define TAG_CHAPTER_UPDATED 1001


//仅限于查看目录和查看评论时, 500条记录以上则每次只加载50条,其余记录保存在缓存中
#define PAGE_LIMIT_NUMBER   500

#define NETWORK_TIME_OUT    60.0f

//通知常量
#define NOTIFICATION_ENTER_BACKGROUND @"enterBackgroundNotification"

//运营相关
#define LOGO4_91	1


