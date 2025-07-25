// utils/HttpRequest.ets
import http from '@ohos.net.http';

export interface HttpResponse<T> {
  success: boolean;
  code: boolean;
  data: T;
  message: string;
}


export class HttpRequest {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  async request<T>(method: http.RequestMethod, url: string, data?: object, headers?: Record<string, string>): Promise<T> {
    const httpRequest = http.createHttp();
    const fullUrl = `${this.baseUrl}${url}`;

    try {
      const response = await httpRequest.request(
        fullUrl,
        {
          method: method,
          header: {
            'Content-Type': 'application/json',
            // ...headers // 正确合并 headers
          },
          extraData: data ? JSON.stringify(data) : undefined,
          connectTimeout: 5000, // 连接超时时间
          readTimeout: 10000 // 读取超时时间
        }
      );

      if (response.responseCode >= 200 && response.responseCode < 300) {
        if (response.result) {
          return JSON.parse(response.result.toString()) as T;
        } else {
          return null as T; // 返回空对象，避免 undefined
        }
      } else {
        throw new Error(`Request failed with status ${response.responseCode}: ${response.result}`);
      }
    } catch (error) {
      console.error(`HTTP Request Error: ${error.message}`);
      throw new Error(String(error)); // 抛出错误以便上层处理
    } finally {
      httpRequest.destroy(); // 销毁请求实例
    }
  }

  get<T>(url: string, params?: object, headers?: Record<string, string>): Promise<T> {
    let query = '';
    if (params) {
      query = Object.keys(params)
        .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
        .join('&');
    }
    const fullUrl = query ? `${url}?${query}` : url;
    return this.request<T>(http.RequestMethod.GET, fullUrl, undefined, headers);
  }

  post<T>(url: string, data: object, headers?: Record<string, string>): Promise<T> {
    return this.request<T>(http.RequestMethod.POST, url, data, headers);
  }

  put<T>(url: string, data: object, headers?: Record<string, string>): Promise<T> {
    return this.request<T>(http.RequestMethod.PUT, url, data, headers);
  }

  delete<T>(url: string, headers?: Record<string, string>): Promise<T> {
    return this.request<T>(http.RequestMethod.DELETE, url, undefined, headers);
  }
}

export interface RequestParams {
  user_id: number;
  sender_id: number;
  receiver_id: number;
  content: string;
}

export class HttpError extends Error {
  public statusCode?: number;

  constructor(message: string, statusCode?: number) {
    super(message);
    this.statusCode = statusCode;
    this.name = 'HttpError';
  }
}

// 本地定义接口
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;

}

// 导出请求实例，可以根据实际后端地址进行配置
// export const httpClient = new HttpRequest('http://10.136.20.176:3000/api'); // 请替换为您的后端实际IP和端口，校园网
export const httpClient = new HttpRequest('http://192.168.123.160:3000/api'); // 请替换为您的后端实际IP和端口，流量
