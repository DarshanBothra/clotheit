import { useState, useEffect } from 'react'
import { useCart } from '../context/CartContext'
import { placeOrder } from '../api'

export default function CartDrawer({ customerId }) {
  const { cart, cartTotal, removeFromCart, updateQty, clearCart } = useCart()
  const [isOpen, setIsOpen] = useState(false)

  useEffect(() => {
    const handler = () => setIsOpen((prev) => !prev)
    window.addEventListener('toggle-cart', handler)
    return () => window.removeEventListener('toggle-cart', handler)
  }, [])

  const closeDrawer = () => setIsOpen(false)

  const handlePlaceOrder = async () => {
    if (cart.length === 0) return
    try {
      const items = cart.map((i) => ({ product_id: i.product_id, qty: i.qty }))
      const res = await placeOrder(customerId, items)
      clearCart()
      closeDrawer()
      alert(`Order placed successfully! Order ID: ${res.order_id ?? res.id ?? '—'}`)
    } catch (err) {
      alert(err.message || 'Failed to place order')
    }
  }

  return (
    <>
      {isOpen && (
        <>
          <div
            className="fixed inset-0 bg-black/30 z-50"
            onClick={closeDrawer}
            aria-hidden="true"
          />
          <div className="fixed right-0 top-0 h-full w-96 max-w-full bg-white shadow-xl z-50 flex flex-col">
        <div className="flex justify-between items-center p-4 border-b border-slate-100">
          <h2 className="text-lg font-semibold text-slate-800">Shopping Cart</h2>
          <button
            onClick={closeDrawer}
            className="p-1 text-slate-500 hover:text-slate-700"
            aria-label="Close"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="flex-1 overflow-y-auto p-4">
          {cart.map((item) => {
            const unitPrice = item.effective_price ?? item.price ?? 0
            const lineTotal = unitPrice * item.qty
            return (
              <div
                key={item.product_id}
                className="py-3 border-b border-slate-100 last:border-0"
              >
                <p className="font-medium text-slate-800">{item.name}</p>
                <p className="text-sm text-slate-500">{item.vendor}</p>
                <p className="text-sm text-slate-600">₹{unitPrice.toFixed(2)} each</p>
                <div className="flex items-center justify-between mt-2">
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => updateQty(item.product_id, item.qty - 1)}
                      className="w-7 h-7 rounded border border-slate-200 text-slate-600 hover:bg-slate-50"
                    >
                      −
                    </button>
                    <span className="text-sm font-medium w-6 text-center">{item.qty}</span>
                    <button
                      onClick={() => updateQty(item.product_id, item.qty + 1)}
                      className="w-7 h-7 rounded border border-slate-200 text-slate-600 hover:bg-slate-50"
                    >
                      +
                    </button>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-medium">₹{lineTotal.toFixed(2)}</span>
                    <button
                      onClick={() => removeFromCart(item.product_id)}
                      className="text-red-500 text-sm hover:text-red-600"
                    >
                      Remove
                    </button>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
        <div className="border-t border-slate-100 p-4">
          <p className="text-xl font-bold text-slate-900 mb-3">
            Total: ₹{cartTotal.toFixed(2)}
          </p>
          <button
            onClick={handlePlaceOrder}
            disabled={cart.length === 0}
            className="w-full bg-indigo-600 hover:bg-indigo-700 disabled:bg-slate-300 disabled:cursor-not-allowed text-white py-3 rounded-lg font-semibold transition"
          >
            Place Order
          </button>
        </div>
          </div>
        </>
      )}
    </>
  )
}
