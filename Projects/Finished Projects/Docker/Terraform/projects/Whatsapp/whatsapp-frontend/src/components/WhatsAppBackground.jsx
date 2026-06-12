import { useEffect, useState } from 'react'

export const WhatsAppBackground = () => {
  const [bubbles, setBubbles] = useState([])

  useEffect(() => {
    // Generate random chat bubbles
    const generateBubbles = () => {
      const newBubbles = Array.from({ length: 15 }, (_, i) => ({
        id: i,
        left: Math.random() * 100,
        top: Math.random() * 100,
        width: 60 + Math.random() * 200,
        height: 30 + Math.random() * 60,
        duration: 8 + Math.random() * 12,
        delay: Math.random() * 5,
        opacity: 0.05 + Math.random() * 0.15,
      }))
      setBubbles(newBubbles)
    }

    generateBubbles()
  }, [])

  return (
    <div className="fixed inset-0 overflow-hidden pointer-events-none">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-whatsapp-dark via-whatsapp-darkBg to-whatsapp-dark" />

      {/* Animated chat bubbles */}
      {bubbles.map((bubble) => (
        <div
          key={bubble.id}
          className="absolute rounded-3xl border border-whatsapp-primary/20 animate-float"
          style={{
            left: `${bubble.left}%`,
            top: `${bubble.top}%`,
            width: `${bubble.width}px`,
            height: `${bubble.height}px`,
            opacity: bubble.opacity,
            backgroundColor: `rgba(37, 211, 102, ${bubble.opacity * 0.3})`,
            animation: `float ${bubble.duration}s ease-in-out ${bubble.delay}s infinite`,
          }}
        >
          {/* Inner shine */}
          <div
            className="absolute inset-0 rounded-3xl opacity-0"
            style={{
              background: `linear-gradient(135deg, rgba(255,255,255,0.1) 0%, transparent 100%)`,
              animation: `shimmer ${bubble.duration * 2}s ease-in-out ${bubble.delay}s infinite`,
            }}
          />
        </div>
      ))}

      {/* Larger background elements */}
      <div
        className="absolute -top-40 -right-40 w-80 h-80 rounded-full opacity-5"
        style={{
          background: 'radial-gradient(circle, #25D366 0%, transparent 70%)',
          animation: 'float 20s ease-in-out infinite',
        }}
      />
      <div
        className="absolute -bottom-40 -left-40 w-80 h-80 rounded-full opacity-5"
        style={{
          background: 'radial-gradient(circle, #25D366 0%, transparent 70%)',
          animation: 'float 25s ease-in-out 5s infinite',
        }}
      />
    </div>
  )
}
