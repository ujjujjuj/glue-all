import { useEffect, useState } from "react";
import { Routes, Route, useNavigate } from "react-router-dom";
import Home from "./pages/Home";
import Login from "./pages/Login";

function App() {
  const [auth, setAuth] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    if (auth) {
      navigate("/");
      window.ipc.invoke("setAuth", auth.token);
    } else {
      navigate("/login");
    }
  }, [auth, navigate]);

  return (
    <div>
      <Routes>
        <Route
          path="/login"
          element={<Login auth={auth} setAuth={setAuth} />}
        />
        <Route path="/" element={<Home auth={auth} setAuth={setAuth} />} />
      </Routes>
    </div>
  );
}

export default App;
