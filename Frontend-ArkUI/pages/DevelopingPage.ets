/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { router } from '@kit.ArkUI';

@Entry
@Component
struct DevelopingPage {
  @State pageName: string = '该功能';

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['pageName']) {
      this.pageName = params['pageName'];
    }
  }

  build() {
    Column() {
      Image($r('app.media.developing'))
        .width(200)
        .height(200)
        .margin({ bottom: 30 })

      Text(`${this.pageName}功能正在开发中`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Text('我们的团队正在努力开发中，敬请期待！')
        .fontSize(16)
        .fontColor('#666')
        .margin({ bottom: 30 })

      Button('返回')
        .width(120)
        .height(40)
        .fontSize(16)
        .onClick(() => {
          router.back()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#f5f5f5')
  }
}