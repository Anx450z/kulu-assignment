import react, { useState, useEffect } from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { ToastContainer } from 'react-toastify'
import GoogleLogin from './components/GoogleLogin'
import { registerIntercepts, setAuthHeaders } from './services/api'
import AuthCallback from './components/AuthCallback'
import { isLoggedIn }  from './services/storage'
import { Dashboard } from './components/Dashboard'
import { Project } from './components/Project'

const PrivateRoute = ({ children }) => {
  return isLoggedIn() ? children : <Navigate to="/login" />
}

const App = () => {
  const [loading, setLoading] = useState(true)
  useEffect(() => {
    setAuthHeaders(setLoading)
    registerIntercepts()
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
          <Route
            path="/dashboard"
            element={
              <PrivateRoute>
                <Dashboard/>
              </PrivateRoute>
            }
          />
          <Route path="/project/:id"
            element={
              <PrivateRoute>
                <Project/>
              </PrivateRoute>
            }
          />
        </Routes>
      </BrowserRouter>
      <ToastContainer />
    </>
  )
}

export default App
