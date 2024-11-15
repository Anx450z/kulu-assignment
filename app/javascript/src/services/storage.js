const setToLocalStorage = (authToken, email) => {
  localStorage.setItem('authToken', JSON.stringify(authToken))
  localStorage.setItem('authEmail',email)
}

const getFromLocalStorage = (key) => {
  let response = ''
  try {
    const value = localStorage.getItem(key)
    response = value ? JSON.parse(value) : null
  } catch (error) {
    console.error(error)
    response = ''
  }
  return response
}

const isLoggedIn = () => {
  return getFromLocalStorage('authToken') !== null
}

export { setToLocalStorage, getFromLocalStorage, isLoggedIn }
