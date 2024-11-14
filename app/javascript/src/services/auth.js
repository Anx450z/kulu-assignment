const AUTH_TOKEN = 'auth_token';

export const authService = {
  setToken(token) {
    localStorage.setItem(AUTH_TOKEN, token);
  },

  getToken() {
    return localStorage.getItem(AUTH_TOKEN);
  },

  removeToken() {
    localStorage.removeItem(AUTH_TOKEN);
  },

  isAuthenticated() {
    return !!this.getToken();
  }
};
