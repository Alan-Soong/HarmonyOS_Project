// const Koa = require('koa')
// const app = new Koa()
// const views = require('koa-views')
// const json = require('koa-json')
// const onerror = require('koa-onerror')
// const bodyparser = require('koa-bodyparser')
// const logger = require('koa-logger')

// const index = require('./routes/index')
// const users = require('./routes/users')

// // error handler
// onerror(app)

// // middlewares
// app.use(bodyparser({
//   enableTypes:['json', 'form', 'text']
// }))
// app.use(json())
// app.use(logger())
// app.use(require('koa-static')(__dirname + '/public'))

// app.use(views(__dirname + '/views', {
//   extension: 'pug'
// }))

// // logger
// app.use(async (ctx, next) => {
//   const start = new Date()
//   await next()
//   const ms = new Date() - start
//   console.log(`${ctx.method} ${ctx.url} - ${ms}ms`)
// })

// // routes
// app.use(index.routes(), index.allowedMethods())
// app.use(users.routes(), users.allowedMethods())

// // error-handling
// app.on('error', (err, ctx) => {
//   console.error('server error', err, ctx)
// });

// module.exports = app

const Koa = require('koa');
const app = new Koa();
const Router = require('koa-router');
const bodyParser = require('koa-bodyparser');
const onerror = require('koa-onerror');
const cors = require('@koa/cors');
const koaStatic = require('koa-static');
const views = require('koa-views');
const logger = require('koa-logger');
require('dotenv').config();

const router = new Router();
// router.get('/', async (ctx) => {
//   ctx.body = 'Hello from Koa2!';
// });

// 添加错误处理
onerror(app);

// CORS配置
app.use(cors({
  origin: '*', // 在生产环境中应该设置为特定的域名
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowHeaders: ['Content-Type', 'Authorization']
}));

// 静态文件服务
app.use(koaStatic(__dirname + '/public'));

// 视图引擎
app.use(views(__dirname + '/views', {
  extension: 'pug'
}));

// 日志中间件
app.use(logger());

// 全局错误处理中间件
app.use(async (ctx, next) => {
  try {
    await next();
  } catch (err) {
    console.error('Error:', err);
    ctx.status = err.status || 500;
    ctx.body = { 
      success: false,
      message: err.message || 'Internal Server Error',
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    };
  }
});

// 请求体解析
app.use(bodyParser({
  enableTypes: ['json', 'form', 'text'],
  jsonLimit: '10mb',
  formLimit: '10mb',
  textLimit: '10mb'
}));

// Import routes
const routes = require('./routes');

// Use routes
app.use(routes.routes()).use(routes.allowedMethods());

// 导出 Koa 实例
module.exports = app;