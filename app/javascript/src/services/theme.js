export const saveTheme = theme => {
  localStorage.setItem('theme', theme)
}
export const setTheme = () => {
  const theme = localStorage.getItem('theme')
  if (theme === 'dark') {
    document.body.classList.add('dark')
  } else {
    document.body.classList.remove('dark')
  }
}
