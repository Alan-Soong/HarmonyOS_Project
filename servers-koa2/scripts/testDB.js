const mysql = require('mysql2/promise');
require('dotenv').config();

async function testDatabaseConnection() {
  try {
    // 先测试基本连接（不指定数据库）
    const basicConnection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT || 3306
    });
    
    console.log('✅ 数据库服务器连接成功');
    
    // 检查数据库是否存在
    const [databases] = await basicConnection.execute('SHOW DATABASES');
    const dbExists = databases.some(db => db.Database === process.env.DB_DATABASE);
    
    if (!dbExists) {
      console.log(`❌ 数据库 '${process.env.DB_DATABASE}' 不存在`);
      console.log('请创建数据库或检查 .env 文件中的 DB_DATABASE 配置');
      await basicConnection.end();
      return false;
    }
    
    console.log(`✅ 数据库 '${process.env.DB_DATABASE}' 存在`);
    
    // 测试完整连接
    const fullConnection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_DATABASE,
      port: process.env.DB_PORT || 3306
    });
    
    console.log('✅ 完整数据库连接成功');
    
    // 检查表是否存在
    const [tables] = await fullConnection.execute('SHOW TABLES');
    console.log('📋 数据库中的表:', tables.map(t => Object.values(t)[0]));
    
    await basicConnection.end();
    await fullConnection.end();
    return true;
    
  } catch (error) {
    console.error('❌ 数据库连接失败:', error.message);
    console.error('请检查以下配置:');
    console.error('- 数据库服务是否启动');
    console.error('- .env 文件中的数据库配置是否正确');
    console.error('- 用户权限是否足够');
    return false;
  }
}

// 如果直接运行这个脚本
if (require.main === module) {
  testDatabaseConnection();
}

module.exports = testDatabaseConnection;
