import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import './App.css'
const App = () => {
  return (
    <Router>
          <Routes>
            <Route
              path="/"
              element={
                <div className="container">
                  <h1>Hello world!</h1>
                </div>
              }
            />
          </Routes>
    </Router>
  );
};

export default App
