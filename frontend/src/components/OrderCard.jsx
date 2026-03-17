import { useState } from 'react'
import StatusBadge from './StatusBadge'
import DataTable from './DataTable'

export default function OrderCard({ order }) {
  const [expanded, setExpanded] = useState(false)
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
        </div>
      )}
    </div>
  )
}
