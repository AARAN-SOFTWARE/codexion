import { Routes, Route, useLocation } from 'react-router-dom';
import Home from './pages/app/Home';
import Cart from './pages/app/Cart';
import Footer from './Components/footer/Footer';
import Login from './pages/auth/Login';
import SignUp from './pages/auth/Signup';
import ProductPage from './UIBlocks/ProductPage';
import CategoryPage from './UIBlocks/CategoryPage';
import NotFound from './Components/NotFound';
import ProductForm from './pages/app/Forms/ProductForm';
import Wishlist from './UIBlocks/Wishlist';
import Admin from './pages/app/Admin';
import Header from './Components/Header/Header';
import "animate.css";

function AppRoutes() {
  const location = useLocation();
  const hideLayout =
    location.pathname === '/login' ||
    location.pathname === '/signup' ||
    location.pathname.startsWith('/admin');
  return (
    <>
      {!hideLayout && <Header />}

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/cart" element={<Cart />} />
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/productpage/:id" element={<ProductPage />} />
        <Route path="/category/:category" element={<CategoryPage />} />
        <Route path="wishlist" element={<Wishlist />} />
        <Route path="/productform" element={<ProductForm />} />
        <Route path="/admin/:component?" element={<Admin />} />
        <Route path="*" element={<NotFound />} />
      </Routes>

      {!hideLayout && <Footer />}
    </>
  );
}

export default AppRoutes;
