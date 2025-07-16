import { BrowserRouter as Router } from 'react-router-dom';
import { ThemeProvider } from './Components/theme-provider.tsx';
import AppRoutes from './AppRoutes.tsx'; // child that can use useLocation
// styles for PrimeReact
import "primereact/resources/themes/lara-light-blue/theme.css" // or another theme
import "primereact/resources/primereact.min.css"
import "primeicons/primeicons.css"

function App() {
  return (
    <ThemeProvider defaultTheme="system" storageKey="vite-ui-theme">
      <Router>
        <AppRoutes />
      </Router>
    </ThemeProvider>
  );
}

export default App;
