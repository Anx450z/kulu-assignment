import { authService } from './auth'

const BASE_URL = 'http://localhost:3000/api'

export const apiService = {
  async request(endpoint, options = {}) {
    const token = authService.getToken()

    const headers = {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options.headers,
    }

    const response = await fetch(`${BASE_URL}${endpoint}`, {
      ...options,
      headers,
    })

    if (!response.ok) {
      if (response.status === 401) {
        authService.removeToken()
        window.location.href = '/login'
      }
      throw new Error('API request failed')
    }

    return response.json()
  },

  get(endpoint) {
    return this.request(endpoint, { method: 'GET' })
  },

  post(endpoint, data) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    })
  },
}
