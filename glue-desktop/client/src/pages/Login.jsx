import { useState } from "react";
import { Navigate } from "react-router-dom";

const Login = ({ auth, setAuth }) => {
  const [name, setName] = useState("");
  const [token, setToken] = useState("");

  if (auth) return <Navigate to="/" />;

  const handleLogin = () => {
    setAuth({ name, token });
  };

  return (
    <div className="flex flex-col gap-4 justify-center items-center w-screen h-screen bg-gray-100 loginwindow">
      <div className="mb-8 text-5xl font-bold">Glue</div>
      <input
        value={name}
        onChange={(e) => setName(e.target.value)}
        className="p-3 w-80 bg-gray-200"
        placeholder="Enter Name"
      />
      <input
        value={token}
        onChange={(e) => setToken(e.target.value)}
        className="p-3 w-80 bg-gray-200"
        placeholder="Enter token"
      />
      <button
        className="py-3 w-80 font-bold text-white bg-gray-800 rounded transition-opacity hover:opacity-70"
        onClick={handleLogin}
      >
        Login
      </button>
    </div>
  );
};

export default Login;
