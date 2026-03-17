import { useState } from 'react'
import { Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar'
import CartDrawer from './components/CartDrawer'
import ShopPage from './pages/ShopPage'
import OrdersPage from './pages/OrdersPage'
import AnalyticsPage from './pages/AnalyticsPage'

function App() {
  const [customerId, setCustomerId] = useState(1)

  return (
    <div className="min-h-screen bg-slate-50">
      <Navbar customerId={customerId} setCustomerId={setCustomerId} />
      <main>
        <Routes>
          <Route path="/" element={<ShopPage customerId={customerId} />} />
          <Route path="/orders" element={<OrdersPage customerId={customerId} />} />
          <Route path="/analytics" element={<AnalyticsPage />} />
        </Routes>
      </main>
      <CartDrawer customerId={customerId} />
    </div>
  )
}

export default App
