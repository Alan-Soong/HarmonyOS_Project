import { CommonConstants } from '../constants/CommonConstants';
import { router } from '@kit.ArkUI';
import { httpClient, HttpError } from '../utils/HttpRequest';
import { LoginRequest, LoginResponse } from '../models/login';
import promptAction from '@ohos.promptAction';
import { UserStore } from '../models/UserStore';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

@Entry
@Component
export struct LoginPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isRegisterMode: boolean = false;
  @State avatarUrl: string = '';
  @State errorMessage: string = '';
  @State token: string = '';
  @State showPassword: boolean = false;
  @State showConfirmPassword: boolean = false;
  @State isUploading: boolean = false;
  @State avatarPreview: string = '';

  private validatePassword(password: string): boolean {
    const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
    return regex.test(password);
  }

  async login() {
    this.errorMessage = '';
    if (!this.username || !this.password) {
      this.errorMessage = '用户名和密码不能为空';
      return;
    }

    try {
      const response = await httpClient.post<LoginResponse>('/users/login', {
        username: this.username,
        password: this.password,
        avatar_url: this.avatarUrl || null
      } as LoginRequest);

      if (response.success && response.data) {
        console.log('Login successful:', JSON.stringify(response.data));

        const userId = response.data.user_id;
        const username = response.data.username;

        if (!userId || !username) {
          throw new Error('用户ID或用户名为空');
        }

        UserStore.setCurrentUserId(userId);
        UserStore.setCurrentUsername(username);
        AppStorage.setOrCreate('currentUserId', userId);
        AppStorage.setOrCreate('currentUsername', username);

        promptAction.showToast({
          message: '登录成功',
          duration: 2000
        });

        router.replaceUrl({
          url: 'pages/Index',
          params: {
            isLoggedIn: true,
            username: username,
            avatarUrl: response.data.avatar_url || ''
          }
        });
      } else {
        this.errorMessage = response.message || '登录失败，请检查用户名或密码';
        promptAction.showToast({
          message: this.errorMessage,
          duration: 2000
        });
      }
    } catch (err) {
      this.errorMessage = err instanceof HttpError ? err.message : '网络错误或服务器无响应';
      console.error('Login request error:', err);
      promptAction.showToast({
        message: this.errorMessage,
        duration: 2000
      });
    }
  }

  async register() {
    this.errorMessage = '';

    if (!this.username) {
      this.errorMessage = '用户名不能为空';
      return;
    }

    if (!this.password || !this.confirmPassword) {
      this.errorMessage = '密码和确认密码不能为空';
      return;
    }

    if (this.password !== this.confirmPassword) {
      this.errorMessage = '两次输入的密码不一致';
      return;
    }

    if (!this.validatePassword(this.password)) {
      this.errorMessage = '密码必须至少8个字符，包含字母和数字';
      return;
    }

    try {
      const response = await httpClient.post<LoginResponse>('/users', {
        username: this.username,
        password: this.password,
        avatar_url: this.avatarUrl || null
      } as LoginRequest);

      if (response.success) {
        console.log('Registration successful:', JSON.stringify(response.data));
        promptAction.showToast({
          message: '注册成功，请登录！',
          duration: 2000
        });
        this.isRegisterMode = false;
        this.password = '';
        this.confirmPassword = '';
      } else {
        this.errorMessage = response.message || '注册失败';
      }
    } catch (err) {
      this.errorMessage = err instanceof HttpError ? err.message : '网络错误或服务器无响应';
      console.error('Registration request error:', err);
    }
  }

  build() {
    Stack() {
      // 背景图片（固定在底层不滚动）
      Image($r('app.media.login_bg'))
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .objectFit(ImageFit.Cover)

      // 主内容区域（可滚动）
      Scroll() {
        Column() {
          // 顶部logo和标题（这部分不需要滚动）
          Column() {
            Image($r('app.media.icon_application1'))
              .width(260)
              .height(260)
              .margin({ bottom: 10 })

            Text(this.isRegisterMode ? '注册美食账号' : '本地美食指南')
              .fontSize(24)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 30 })
          }
          .width(CommonConstants.FULL_PERCENT)
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 50 })

          // 表单卡片区域（可滚动部分）
          Column() {
            // 用户名输入
            Row() {
              Image($r('app.media.default_avatar'))
                .width(20)
                .height(20)
                .margin({ right: 10 })
                .fillColor('#FFA500')

              TextInput({ placeholder: '用户名', text: this.username })
                .onChange((value: string) => this.username = value)
                .width('85%')
                .height(40)
                .fontSize(16)
            }
            .width('90%')
            .padding(10)
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 20 })

            // 密码输入
            Row() {
              Image($r('app.media.icon_block'))
                .width(20)
                .height(20)
                .margin({ right: 10 })
                .fillColor('#FFA500')

              TextInput({
                placeholder: '密码',
                text: this.password
              })
                .onChange((value: string) => this.password = value)
                .width('85%')
                .height(40)
                .fontSize(16)
                .type(this.showPassword ? InputType.Normal : InputType.Password)
            }
            .width('90%')
            .padding(10)
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .margin({ bottom: 20 })

            // 注册时的额外字段
            if (this.isRegisterMode) {
              // 确认密码
              Row() {
                Image($r('app.media.icon_block'))
                  .width(20)
                  .height(20)
                  .margin({ right: 10 })
                  .fillColor('#FFA500')

                TextInput({
                  placeholder: '确认密码',
                  text: this.confirmPassword
                })
                  .onChange((value: string) => this.confirmPassword = value)
                  .width('85%')
                  .height(40)
                  .fontSize(16)
                  .type(this.showConfirmPassword ? InputType.Normal : InputType.Password)
              }
              .width('90%')
              .padding(10)
              .borderRadius(8)
              .backgroundColor('#FFFFFF')
              .margin({ bottom: 20 })

              // 头像URL
              Row() {
                Image($r('app.media.icon_camera'))
                  .width(20)
                  .height(20)
                  .margin({ right: 10 })
                  .fillColor('#FFA500')

                TextInput({ placeholder: '头像URL (可选)', text: this.avatarUrl })
                  .onChange((value: string) => this.avatarUrl = value)
                  .width('85%')
                  .height(40)
                  .fontSize(16)
              }
              .width('90%')
              .padding(10)
              .borderRadius(8)
              .backgroundColor('#FFFFFF')
              .margin({ bottom: 20 })
            }

            // 操作按钮区域
            Column() {
              // 登录/注册按钮
              Button(this.isRegisterMode ? '注册' : '登录')
                .width('90%')
                .height(45)
                .fontSize(18)
                .fontColor(Color.White)
                .backgroundColor('#FFA500')
                .borderRadius(22)
                .margin({ bottom: 20 })
                .onClick(() => {
                  if (this.isRegisterMode) {
                    this.register();
                  } else {
                    this.login();
                  }
                })

              // 切换登录/注册模式
              Row() {
                Text(this.isRegisterMode ? '已有账号？' : '没有账号？')
                  .fontColor('#666666')

                Text(this.isRegisterMode ? '去登录' : '去注册')
                  .fontColor('#FFA500')
                  .margin({ left: 5 })
                  .onClick(() => {
                    this.isRegisterMode = !this.isRegisterMode;
                    this.errorMessage = '';
                    this.password = '';
                    this.confirmPassword = '';
                  })
              }
              .margin({ bottom: 20 })

              // 错误信息显示
              if (this.errorMessage) {
                Text(this.errorMessage)
                  .fontColor(Color.Red)
                  .fontSize(14)
                  .textAlign(TextAlign.Center)
                  .width('90%')
                  .margin({ bottom: 10 })
              }
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 4 })
        }
        .width(CommonConstants.FULL_PERCENT)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .margin({bottom:-30})
  }
}