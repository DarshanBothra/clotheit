import { useState, useEffect } from 'react'
import {
  fetchLowStock,
  fetchCustomerAnalytics,
  fetchVendorAnalytics,
  fetchMonthlyAnalytics,
  fetchTopProducts,
  fetchComplaints,
} from '../api'
import DataTable from '../components/DataTable'
import TierBadge from '../components/TierBadge'

const TABS = [
  { id: 'low-stock', label: 'Low Stock' },
  { id: 'customers', label: 'Customers' },
  { id: 'vendors', label: 'Vendors' },
  { id: 'monthly', label: 'Monthly Sales' },
  { id: 'top-products', label: 'Top Products' },
  { id: 'complaints', label: 'Complaints' },
]

const FETCHERS = {
  'low-stock': () => fetchLowStock(200),
  customers: fetchCustomerAnalytics,
  vendors: fetchVendorAnalytics,
  monthly: fetchMonthlyAnalytics,
  'top-products': () => fetchTopProducts(15),
  complaints: fetchComplaints,
}

export default function AnalyticsPage() {
  const [activeTab, setActiveTab] = useState('low-stock')
  const [data, setData] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    setLoading(true)
    FETCHERS[activeTab]()
      .then(setData)
      .finally(() => setLoading(false))
  }, [activeTab])

  const formatDate = (val) =>
    val ? new Date(val).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }) : '—'

  const renderCell = (row, col) => {
    if (activeTab === 'low-stock' && col.key === 'status') {
      const s = row.status
      const cls = s === 'OUT OF STOCK' ? 'bg-red-500/90 text-white' : s === 'LOW STOCK' ? 'bg-amber-500/90 text-white' : 'bg-slate-200 text-slate-700'
      return <span className={`px-2 py-0.5 rounded text-xs font-medium ${cls}`}>{s}</span>
    }
    if (activeTab === 'customers') {
      if (col.key === 'tier') return <TierBadge tier={row.tier} />
      if (col.key === 'total_spent' || col.key === 'avg_order_value')
        return `₹${(row[col.key] ?? 0).toFixed(2)}`
    }
    if (activeTab === 'vendors' && col.key === 'revenue')
      return `₹${(row.revenue ?? 0).toFixed(2)}`
    if (activeTab === 'top-products' && col.key === 'revenue')
      return `₹${(row.revenue ?? 0).toFixed(2)}`
    if (activeTab === 'complaints') {
      if (col.key === 'open_count' && (row.open_count ?? 0) > 0)
        return <span className="text-red-600 font-medium">{row.open_count}</span>
      if (col.key === 'first_complaint' || col.key === 'latest_complaint')
        return formatDate(row[col.key])
    }
  }

  const lowStockColumns = [
    { key: 'id', label: 'ID' },
    { key: 'product', label: 'Product' },
    { key: 'vendor', label: 'Vendor' },
    { key: 'stock', label: 'Stock', align: 'right' },
    { key: 'price', label: 'Price', align: 'right' },
    { key: 'status', label: 'Status' },
  ]

  const customerColumns = [
    { key: 'id', label: 'ID' },
    { key: 'name', label: 'Name' },
    { key: 'email', label: 'Email' },
    { key: 'total_orders', label: 'Orders', align: 'right' },
    { key: 'total_spent', label: 'Total Spent', align: 'right' },
    { key: 'avg_order_value', label: 'Avg Order', align: 'right' },
    { key: 'tier', label: 'Tier' },
  ]

  const vendorColumns = [
    { key: 'vendor', label: 'Vendor' },
    { key: 'brand', label: 'Brand' },
    { key: 'products_listed', label: 'Products', align: 'right' },
    { key: 'total_inventory', label: 'Inventory', align: 'right' },
    { key: 'orders_fulfilled', label: 'Orders', align: 'right' },
    { key: 'revenue', label: 'Revenue', align: 'right' },
  ]

  const monthlyColumns = [
    { key: 'month', label: 'Month' },
    { key: 'orders', label: 'Orders', align: 'right' },
    { key: 'revenue', label: 'Revenue', align: 'right' },
    { key: 'avg_order', label: 'Avg Order', align: 'right' },
  ]

  const topProductsColumns = [
    { key: '_rank', label: '#' },
    { key: 'product', label: 'Product' },
    { key: 'vendor', label: 'Vendor' },
    { key: 'units_sold', label: 'Units Sold', align: 'right' },
    { key: 'revenue', label: 'Revenue', align: 'right' },
  ]

  const complaintColumns = [
    { key: 'customer', label: 'Customer' },
    { key: 'total_complaints', label: 'Total', align: 'right' },
    { key: 'open_count', label: 'Open', align: 'right' },
    { key: 'resolved_count', label: 'Resolved', align: 'right' },
    { key: 'closed_count', label: 'Closed', align: 'right' },
    { key: 'first_complaint', label: 'First Filed' },
    { key: 'latest_complaint', label: 'Latest' },
  ]

  const COLUMNS = {
    'low-stock': lowStockColumns,
    customers: customerColumns,
    vendors: vendorColumns,
    monthly: monthlyColumns,
    'top-products': topProductsColumns,
    complaints: complaintColumns,
  }

  const tableData = activeTab === 'top-products'
    ? data.map((r, i) => ({ ...r, _rank: i + 1 }))
    : data

  const monthlyRenderCell = (row, col) => {
    if (col.key === 'revenue') {
      const max = data.length ? Math.max(...data.map((r) => r.revenue ?? 0)) : 0
      const pct = max > 0 ? ((row.revenue ?? 0) / max) * 100 : 0
      return (
        <div className="flex items-center gap-2">
          <span>₹{(row.revenue ?? 0).toFixed(2)}</span>
          <div className="w-16 h-2 bg-slate-100 rounded-full overflow-hidden shrink-0">
            <div className="h-full bg-indigo-500 rounded-full" style={{ width: `${pct}%` }} />
          </div>
        </div>
      )
    }
    if (col.key === 'avg_order') return `₹${(row.avg_order ?? 0).toFixed(2)}`
    return undefined
  }

  const getRenderCell = () => {
    if (activeTab === 'monthly') return monthlyRenderCell
    return renderCell
  }

  return (
    <div className="min-h-screen bg-slate-50 p-6">
      <h1 className="text-2xl font-bold text-slate-800 mb-6">Analytics</h1>

      <div className="flex gap-1 bg-slate-100 p-1 rounded-xl mb-6">
        {TABS.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`px-4 py-2 rounded-lg text-sm font-medium transition ${
              activeTab === tab.id
                ? 'bg-white text-indigo-600 shadow-sm'
                : 'text-slate-500 hover:text-slate-700'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="flex justify-center items-center py-16 text-slate-500">
          Loading...
        </div>
      ) : (
        <div className="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
          <DataTable
            columns={COLUMNS[activeTab]}
            data={tableData}
            renderCell={getRenderCell()}
          />
        </div>
      )}
    </div>
  )
}
