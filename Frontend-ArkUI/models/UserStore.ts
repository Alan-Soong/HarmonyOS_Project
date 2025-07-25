export class UserStore {
    // 获取当前用户ID
    static getCurrentUserId(): number {
        const userId = AppStorage.get<number>('currentUserId');
        console.info('Fetching current user ID:', userId); // 添加日志以便调试
        return userId;
    }

    // 设置当前用户ID
    static setCurrentUserId(userId: number | undefined): void {
        if (userId === undefined || userId === null) {
            // 清除用户ID
            AppStorage.delete('currentUserId');
            console.info('Cleared current user ID');
        } else {
            AppStorage.setOrCreate('currentUserId', userId);
            console.info('Set current user ID:', userId);
        }
    }

    // 获取当前用户名
    static getCurrentUsername(): string {
        const username = AppStorage.get<string>('currentUsername');
        console.info('Fetching current username:', username); // 添加日志以便调试
        return username;
    }

    // 设置当前用户名
    static setCurrentUsername(username: string): void {
        if (!username) {
            AppStorage.delete('currentUsername');
            console.info('Cleared current username');
        } else {
            AppStorage.setOrCreate('currentUsername', username);
            console.info('Set current username:', username);
        }
    }


    // 新增：获取头像URL
    static getAvatarUrl(): string | undefined {
        const avatarUrl = AppStorage.get<string>('avatarUrl');
        console.info('Fetching avatar URL:', avatarUrl); // 添加日志以便调试
        return avatarUrl;
    }

    // 设置头像URL
    static setAvatarUrl(avatarUrl: string | undefined): void {
        if (!avatarUrl) {
            AppStorage.delete('avatarUrl');
            console.info('Cleared avatar URL');
        } else {
            AppStorage.setOrCreate('avatarUrl', avatarUrl);
            console.info('Set avatar URL:', avatarUrl);
        }
    }
}