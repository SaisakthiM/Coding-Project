export const PatternBackground = ({ isDark = true }) => {
  return (
    <div className="fixed inset-0 pointer-events-none overflow-hidden">
      {/* SVG Background Pattern */}
      <svg
        className="absolute inset-0 w-full h-full"
        preserveAspectRatio="xMidYMid slice"
        style={{
          opacity: isDark ? 0.15 : 0.08,
          background: isDark
            ? 'linear-gradient(135deg, #111B21 0%, #0A0E11 100%)'
            : 'linear-gradient(135deg, #FAF9F7 0%, #F5F3F0 100%)',
        }}
      >
        <defs>
          <pattern
            id="iconPattern"
            x="0"
            y="0"
            width="100"
            height="100"
            patternUnits="userSpaceOnUse"
          >
            {/* Chat Icon */}
            <circle cx="15" cy="15" r="8" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <path d="M10 15h10" stroke="currentColor" strokeWidth="1.5" />
            <path d="M10 20h8" stroke="currentColor" strokeWidth="1.5" />

            {/* Phone Icon */}
            <rect x="45" y="8" width="16" height="24" rx="2" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <circle cx="53" cy="28" r="1.5" fill="currentColor" />

            {/* Star Icon */}
            <path
              d="M80 10l2.4 7.2h7.6L82.4 20l2.4 7.2-5.8-4.2-5.8 4.2 2.4-7.2-5.8-4.2h7.6"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            />

            {/* Heart Icon */}
            <path
              d="M25 28c0-2.2 1.8-4 4-4 1.2 0 2.3.5 3 1.3.7-.8 1.8-1.3 3-1.3 2.2 0 4 1.8 4 4 0 4-5 7-7 7s-7-3-7-7"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            />

            {/* Camera Icon */}
            <circle cx="18" cy="55" r="5" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <path d="M8 50h12l2 4h-16z" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <circle cx="18" cy="55" r="2" fill="currentColor" />

            {/* Document Icon */}
            <rect x="50" y="48" width="8" height="12" rx="1" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <line x1="52" y1="52" x2="56" y2="52" stroke="currentColor" strokeWidth="1" />
            <line x1="52" y1="55" x2="56" y2="55" stroke="currentColor" strokeWidth="1" />

            {/* Settings Icon */}
            <circle cx="78" cy="58" r="4" fill="none" stroke="currentColor" strokeWidth="1.5" />
            <path d="M78 52v-2M78 66v-2M85 58h2M71 58h-2" stroke="currentColor" strokeWidth="1.5" />

            {/* Bell Icon */}
            <path
              d="M15 82c0-2 1.5-4 3.5-4h3c2 0 3.5 2 3.5 4h-10z"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.5"
            />
            <path d="M19 86v1M19 86c-2 0-3-1-3-2h12c0 1-1 2-3 2" fill="none" stroke="currentColor" strokeWidth="1" />

            {/* Checkmark Icon */}
            <path d="M52 88l2 2 4-5" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />

            {/* Arrow Icon */}
            <path d="M75 85l3-3m0 0l-3-3m3 3h-8" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" />

            {/* Dots */}
            {[...Array(20)].map((_, i) => (
              <circle
                key={i}
                cx={Math.random() * 100}
                cy={Math.random() * 100}
                r="1"
                fill="currentColor"
                opacity="0.4"
              />
            ))}
          </pattern>
        </defs>

        <rect width="100%" height="100%" fill={isDark ? '#0A0E11' : '#FAF9F7'} />
        <rect width="100%" height="100%" fill="url(#iconPattern)" stroke={isDark ? '#25D366' : '#666'} />
      </svg>

      {/* Gradient Overlay */}
      <div
        className="absolute inset-0"
        style={{
          background: isDark
            ? 'radial-gradient(circle at 30% 50%, rgba(37, 211, 102, 0.1) 0%, transparent 50%)'
            : 'radial-gradient(circle at 70% 50%, rgba(37, 211, 102, 0.05) 0%, transparent 50%)',
          pointerEvents: 'none',
        }}
      />
    </div>
  )
}
