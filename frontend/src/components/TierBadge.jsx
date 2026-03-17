const TIER_STYLES = {
  PLATINUM: 'bg-gradient-to-r from-slate-600 to-slate-400 text-white',
  GOLD: 'bg-gradient-to-r from-amber-500 to-yellow-400 text-white',
  SILVER: 'bg-gradient-to-r from-gray-400 to-gray-300 text-gray-800',
  BRONZE: 'bg-gradient-to-r from-orange-600 to-orange-400 text-white',
}

export default function TierBadge({ tier }) {
  const style = TIER_STYLES[tier?.toUpperCase()] ?? 'bg-slate-100 text-slate-600'
  return (
    <span
      className={`inline-flex px-2.5 py-0.5 rounded-full text-xs font-bold ${style}`}
    >
      {tier ?? '—'}
    </span>
  )
}
