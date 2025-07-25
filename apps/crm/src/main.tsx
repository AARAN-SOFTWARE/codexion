import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";
import AppRoutes from "./Routes";
import { BrowserRouter } from "react-router-dom";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  </React.StrictMode>
);
