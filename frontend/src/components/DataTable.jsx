export default function DataTable({ columns, data, renderCell }) {
  return (
    <div className="overflow-x-auto rounded-xl border border-slate-200">
      <table className="w-full text-sm">
        <thead className="bg-slate-50">
          <tr>
            {columns.map((col) => (
              <th
                key={col.key}
                className={`px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider ${
                  col.align === 'right' ? 'text-right' : 'text-left'
                }`}
              >
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100">
          {data?.map((row, rowIdx) => (
            <tr key={rowIdx} className="hover:bg-slate-50">
              {columns.map((col) => {
                const custom = renderCell?.(row, col)
                const value = custom ?? row[col.key]
                return (
                  <td
                    key={col.key}
                    className={`px-4 py-3 text-slate-700 whitespace-nowrap ${
                      col.align === 'right' ? 'text-right' : ''
                    }`}
                  >
                    {value}
                  </td>
                )
              })}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
