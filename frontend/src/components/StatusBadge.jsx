const STATUS_STYLES = {
  DELIVERED: 'bg-emerald-100 text-emerald-700',
  PROCESSING: 'bg-blue-100 text-blue-700',
  PLACED: 'bg-amber-100 text-amber-700',
  CANCELLED: 'bg-red-100 text-red-700',
  SHIPPED: 'bg-sky-100 text-sky-700',
  PACKAGING: 'bg-violet-100 text-violet-700',
}

export default function StatusBadge({ status }) {
  const style = STATUS_STYLES[status?.toUpperCase()] ?? 'bg-slate-100 text-slate-600'
  return (
    <span
      className={`inline-flex px-2.5 py-0.5 rounded-full text-xs font-semibold ${style}`}
    >
      {status ?? '—'}
    </span>
  )
}
