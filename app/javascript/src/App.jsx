import { BrowserRouter, Route, Routes } from 'react-router-dom'
import './App.css'
import GoogleLogin from './components/GoogleLogin'
import AuthCallback from './components/AuthCallback'
import { authService } from './services/auth'

const PrivateRoute = ({ children }) => {
  return authService.isAuthenticated() ? children : <Navigate to="/login" />
}

const App = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<GoogleLogin />} />
        <Route path="/auth/callback" element={<AuthCallback />} />
        <Route
          path="/dashboard"
          element={
            <PrivateRoute>
              <div>Protected Dashboard</div>
            </PrivateRoute>
          }
        />
      </Routes>
    </BrowserRouter>
  )
}

export default App
