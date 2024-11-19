import axios from 'axios'
import { isLoggedIn, getFromLocalStorage } from './storage'

axios.defaults.baseURL = '/'

export const setAuthHeaders = setLoading => {
  axios.defaults.headers.common = {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    'X-CSRF-Token': document.querySelector('[name="csrf-token"]')?.getAttribute('content'),
  }
  if (isLoggedIn()) {
    axios.defaults.headers.common.Authorization = 'Bearer ' + getFromLocalStorage('authToken')
  }
  setLoading(false)
}

const handleSuccessResponse = (response) => {
  return response
}

const handleErrorResponse = axiosErrorObject => {
  if (axiosErrorObject.response?.status === 401) {
    setTimeout(() => (window.location.href = '/'), 2000)
  }
  if (axiosErrorObject.response?.status === 423) {
    window.location.href = '/'
  }
  return Promise.reject(axiosErrorObject)
}

export const registerIntercepts = () => {
  axios.interceptors.response.use(handleSuccessResponse, error => {
    handleErrorResponse(error)
  })
}
