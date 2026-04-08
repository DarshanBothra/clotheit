import { useState } from 'react'
import StatusBadge from './StatusBadge'
import DataTable from './DataTable'
import { cancelOrder } from '../api'

export default function OrderCard({ order, onRefresh }) {
  const [expanded, setExpanded] = useState(false)
  const [cancelling, setCancelling] = useState(false)
  const [confirmCancel, setConfirmCancel] = useState(false)
  const [error, setError] = useState(null)
  const {
    order_id,
    order_datetime,
    order_total,
    status,
    tracking,
    partner,
    items = [],
  } = order

  const dateStr = order_datetime
    ? new Date(order_datetime).toLocaleDateString(undefined, {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      })
    : '—'

  const canCancel = status !== 'CANCELLED' && status !== 'DELIVERED'

  const handleCancel = async () => {
    if (!confirmCancel) {
      setConfirmCancel(true)
      return
    }
    setCancelling(true)
    setError(null)
    try {
      await cancelOrder(order_id)
      setConfirmCancel(false)
      if (onRefresh) onRefresh()
    } catch (e) {
      setError(e.message || 'Failed to cancel order')
    } finally {
      setCancelling(false)
    }
  }

  const itemColumns = [
    { key: 'product', label: 'Product' },
    { key: 'unit_price', label: 'Unit Price', align: 'right' },
    { key: 'qty', label: 'Qty', align: 'right' },
    { key: 'line_total', label: 'Total', align: 'right' },
  ]

  const itemData = items.map((i) => ({
    ...i,
    unit_price: `₹${(i.unit_price ?? 0).toFixed(2)}`,
    line_total: i.line_total != null ? `₹${Number(i.line_total).toFixed(2)}` : `₹${((i.unit_price ?? 0) * (i.qty ?? 0)).toFixed(2)}`,
  }))

  return (
    <div className="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
      <div
        className="flex justify-between items-center p-4 cursor-pointer hover:bg-slate-50"
        onClick={() => setExpanded((e) => !e)}
      >
        <div>
          <span className="font-semibold text-slate-800">Order #{order_id}</span>
          <span className="text-slate-500 ml-2">{dateStr}</span>
        </div>
        <div className="flex items-center gap-3">
          <StatusBadge status={status} />
          <span className="font-bold text-slate-900">
            ₹{(order_total ?? 0).toFixed(2)}
          </span>
        </div>
      </div>
      {expanded && (
        <div className="border-t border-slate-100 p-4">
          {tracking && (
            <div className="mb-4 flex items-center gap-2">
              <StatusBadge status={tracking.status ?? tracking} />
              {partner && (
                <span className="text-sm text-slate-600">via {partner}</span>
              )}
            </div>
          )}
          {items?.length > 0 && (
            <DataTable columns={itemColumns} data={itemData} />
          )}

          {/* Cancel Order button */}
          {canCancel && (
            <div className="mt-4 flex items-center gap-3">
              {!confirmCancel ? (
                <button
                  id={`cancel-order-${order_id}`}
                  onClick={(e) => { e.stopPropagation(); handleCancel() }}
                  className="px-4 py-2 rounded-lg text-sm font-semibold bg-red-50 text-red-600 border border-red-200 hover:bg-red-100 hover:border-red-300 transition-all duration-200 cursor-pointer"
                >
                  Cancel Order
                </button>
              ) : (
                <>
                  <span className="text-sm text-red-600 font-medium">Are you sure?</span>
                  <button
                    id={`confirm-cancel-${order_id}`}
                    onClick={(e) => { e.stopPropagation(); handleCancel() }}
                    disabled={cancelling}
                    className="px-4 py-2 rounded-lg text-sm font-semibold bg-red-600 text-white hover:bg-red-700 transition-all duration-200 disabled:opacity-50 cursor-pointer"
                  >
                    {cancelling ? 'Cancelling…' : 'Yes, Cancel'}
                  </button>
                  <button
                    onClick={(e) => { e.stopPropagation(); setConfirmCancel(false) }}
                    className="px-4 py-2 rounded-lg text-sm font-semibold bg-slate-100 text-slate-600 hover:bg-slate-200 transition-all duration-200 cursor-pointer"
                  >
                    No, Keep It
                  </button>
                </>
              )}
            </div>
          )}

          {error && (
            <p className="mt-2 text-sm text-red-600">{error}</p>
          )}
        </div>
      )}
    </div>
  )
}
