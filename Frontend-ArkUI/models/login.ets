interface LoginDetail {
  user_id: number;
  username: string;
  avatar_url?: string;
  password: string;
}

export interface LoginResponse {
  success: boolean;
  data: LoginDetail;
  message?: string;
}

// ../models/login.ts 或新建文件 LoginRequest.ts
export interface LoginRequest {
  username: string;
  password: string;
  avatar_url?: string | null;
  token: string;
}
