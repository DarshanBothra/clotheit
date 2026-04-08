import { useState, useEffect, useCallback } from 'react'
import { fetchOrders } from '../api'
import OrderCard from '../components/OrderCard'

export default function OrdersPage({ customerId }) {
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)

  const loadOrders = useCallback(() => {
    if (customerId == null) return
    setLoading(true)
    fetchOrders(customerId)
      .then(setOrders)
      .finally(() => setLoading(false))
  }, [customerId])

  useEffect(() => {
    loadOrders()
  }, [loadOrders])

  return (
    <div className="min-h-screen bg-slate-50 p-6">
      <h1 className="text-2xl font-bold text-slate-800 mb-1">My Orders</h1>
      <p className="text-sm text-slate-500 mb-6">Customer ID: {customerId ?? '—'}</p>

      {loading ? (
        <div className="flex justify-center items-center py-16 text-slate-500">
          Loading...
        </div>
      ) : orders.length === 0 ? (
        <div className="text-center py-16 text-slate-500">
          No orders yet.
        </div>
      ) : (
        <div className="space-y-4">
          {orders.map((order) => (
            <OrderCard key={order.order_id} order={order} onRefresh={loadOrders} />
          ))}
        </div>
      )}
    </div>
  )
}
