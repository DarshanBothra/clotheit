import { NavLink } from 'react-router-dom'
import { useCart } from '../context/CartContext'

export default function Navbar({ customerId, setCustomerId }) {
  const { cartCount } = useCart()

  const handleCartClick = () => {
    window.dispatchEvent(new CustomEvent('toggle-cart'))
  }

  return (
    <nav className="bg-white shadow-sm sticky top-0 z-50 px-6 py-3 flex items-center justify-between">
      <span className="text-xl font-bold text-indigo-600">ClotheIt</span>
      <div className="flex items-center gap-6">
        <NavLink
          to="/"
          className={({ isActive }) =>
            isActive ? 'font-bold text-indigo-600 underline' : 'text-slate-600 hover:text-indigo-600'
          }
        >
          Shop
        </NavLink>
        <NavLink
          to="/orders"
          className={({ isActive }) =>
            isActive ? 'font-bold text-indigo-600 underline' : 'text-slate-600 hover:text-indigo-600'
          }
        >
          My Orders
        </NavLink>
        <NavLink
          to="/analytics"
          className={({ isActive }) =>
            isActive ? 'font-bold text-indigo-600 underline' : 'text-slate-600 hover:text-indigo-600'
          }
        >
          Analytics
        </NavLink>
      </div>
      <div className="flex items-center gap-4">
        <select
          value={customerId}
          onChange={(e) => setCustomerId(Number(e.target.value))}
          className="px-3 py-2 border border-slate-200 rounded-lg text-sm text-slate-700 bg-white"
        >
          {Array.from({ length: 20 }, (_, i) => i + 1).map((n) => (
            <option key={n} value={n}>
              Customer #{n}
            </option>
          ))}
        </select>
        <button
          onClick={handleCartClick}
          className="relative p-2 text-slate-600 hover:text-indigo-600 transition"
          aria-label="Toggle cart"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={1.5}
            stroke="currentColor"
            className="w-6 h-6"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007zM8.625 10.5a.375.375 0 11-.75 0 .375.375 0 01.75 0zm7.5 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"
            />
          </svg>
          {cartCount > 0 && (
            <span className="absolute -top-1 -right-1 bg-indigo-600 text-white text-xs font-bold min-w-[1.25rem] h-5 flex items-center justify-center rounded-full px-1">
              {cartCount}
            </span>
          )}
        </button>
      </div>
    </nav>
  )
}
