import react, { useState, useEffect } from 'react'
import { BrowserRouter, Route, Routes, Navigate, Outlet } from 'react-router-dom'
import GoogleLogin from './components/GoogleLogin'
import { registerIntercepts, setAuthHeaders } from './services/api'
import AuthCallback from './components/AuthCallback'
import { isLoggedIn } from './services/storage'
import { Project } from './components/Project'
import { Projects } from './components/Projects'
import { Task } from './components/Task'
import { setTheme } from './services/theme'

const PrivateRoute = () => {
  return isLoggedIn() ? <Outlet /> : <Navigate to="/login" />
}

const App = () => {
  const [loading, setLoading] = useState(true)
  useEffect(() => {
    setAuthHeaders(setLoading)
    registerIntercepts()
    setTheme()
  }, [])

  if (loading) {
    return <>Loading..</>
  }

  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<GoogleLogin />} />
          <Route path="/auth/callback" element={<AuthCallback />} />
          <Route element={<PrivateRoute />}>
            <Route path="/" element={<Projects />} />
            <Route path="/project/:id" element={<Project />} />
            <Route path="/project/:id/task/:taskId" element={<Task />} />
          </Route>
          <Route path="*" element={<h1>404</h1>} />
        </Routes>
      </BrowserRouter>
    </>
  )
}

export default App
