import axios from "axios";
import { getFromLocalStorage } from "./storage";
const API_URL = '/api/v1/'
const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || ''

export const authService = {
  logout() {
    return axios
      .delete(`${API_URL}sessions`, {
        headers: {
          'X-CSRF-Token': csrfToken,
          'Authorization': 'Bearer ' + getFromLocalStorage('authToken')
        },
      })
      .then(response => {
        if (response.data.success) {
          localStorage.removeItem('authToken')
          localStorage.removeItem('authEmail')
        }
      })
      .catch(error => {
        console.error('Logout failed:', error)
        throw error
      })
  },
}
