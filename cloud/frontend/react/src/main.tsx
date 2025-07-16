import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./theme.css";
import App from "./App.tsx";

import { AppProvider } from "./pages/GlobalContext/AppContaxt.tsx";
import AppInitializer from "./pages/app/useSettings.tsx";
import { AuthProvider } from "./pages/GlobalContext/AuthContext.tsx";
createRoot(document.getElementById("root")!).render(
  <AuthProvider>
    <AppInitializer>
      <AppProvider>
        <StrictMode>
          <App />
        </StrictMode>
      </AppProvider>
    </AppInitializer>
  </AuthProvider>
);
