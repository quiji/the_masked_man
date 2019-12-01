extends Node

static func start2(t): return t * t
static func start3(t): return t * t * t
static func start4(t): return t * t * t * t
static func start5(t): return t * t * t * t * t
static func start6(t): return t * t * t * t * t * t
static func start7(t): return t * t * t * t * t * t * t
static func start8(t): return t * t * t * t * t * t * t * t
static func start9(t): return t * t * t * t * t * t * t * t * t

static func stop2(t): return 1 - (1 - t) * (1 - t) 
static func stop3(t): return 1 - (1 - t) * (1 - t) * (1 - t) 
static func stop4(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) 
static func stop5(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) 
static func stop6(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) 
static func stop7(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) 
static func stop8(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) 
static func stop9(t): return 1 - (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) * (1 - t) 

static func flip(t): return 1 - t

static func blend(smootha, smoothb, weight): return (1 - weight) * smootha + weight * smoothb
static func cross(t, smootha, smoothb): return blend(smootha, smoothb, t)

static func scale(t, smootha): return t * smootha
static func rev_scale(t, smootha): return (1 - t) * smootha

static func arch(t, w=1): return scale(t * w, flip(t))

static func bounce_clamp_bottom(t): return abs(t)

static func bounce_clamp_top(t): return 1.0 - abs(1.0 - t)

static func bezier3(A, B, C, D, t): 
	var s = 1 - t
	var s2 = s * s
	var s3 = s2 * s

	var t2 = t * t
	var t3 = t2 * t
	
	#A*(1-T)^3+3*B*(1-T)^2*T+3*C*(1-T)*T^2+D*T^3
	return A * s3 + 3.0 * B * s2 * t + 3.0 * C * s * t2 + D * t3

# Assumes A is 0 and D is 1.0
static func normalized_bezier3(B, C, t): 
	var s = 1 - t
	var s2 = s * s

	var t2 = t * t
	var t3 = t2 * t
	
	#A*(1-T)^3+3*B*(1-T)^2*T+3*C*(1-T)*T^2+D*T^3
	return  3.0 * B * s2 * t + 3.0 * C * s * t2 + t3

static func bezier7(A, B, C, D, E, F, G, H, t): 
	var s = 1 - t
	var s2 = s * s
	var s3 = s2 * s
	var s4 = s3 * s
	var s5 = s4 * s
	var s6 = s5 * s
	var s7 = s6 * s
	var t2 = t * t
	var t3 = t2 * t
	var t4 = t3 * t
	var t5 = t4 * t
	var t6 = t5 * t
	var t7 = t6 * t
	
	return s7 * A + 7.0 * B * s6 * t + 21.0 * C * s5 * t2 + 35.0 * D * s4 * t3 + 35.0 * E * s3 * t4 + 21.0 * F * s2 * t5 + 7 * G * s * t6 + t7 * H


# Assumes A is 0 and H is 1.0
static func normalized_bezier7(B, C, D, E, F, G, t): 
	var s = 1 - t
	var s2 = s * s
	var s3 = s2 * s
	var s4 = s3 * s
	var s5 = s4 * s
	var s6 = s5 * s
	var t2 = t * t
	var t3 = t2 * t
	var t4 = t3 * t
	var t5 = t4 * t
	var t6 = t5 * t
	var t7 = t6 * t
	
	return 7.0 * B * s6 * t + 21.0 * C * s5 * t2 + 35.0 * D * s4 * t3 + 35.0 * E * s3 * t4 + 21.0 * F * s2 * t5 + 7 * G *s * t6 + t7


############################### Try this using GDNative to see if it overperforms traditional sqrt.
static func fake_sqrt(n):
	var cover = 1000.0
	var cover_sqrt = 31.622777

	if n >= 1 and n < 50.0:
		cover = 10.0
		cover_sqrt = 3.162278
	elif n <= 200.0:
		cover = 100.0
		cover_sqrt = 10.0
	elif n <= 1000.0:
		cover = 500.0
		cover_sqrt = 22.36068
	elif n <= 2000.0:
		cover = 1000.0
		cover_sqrt = 31.622777
	elif n <= 4000.0:
		cover = 2000.0
		cover_sqrt = 44.72136
	else:
		cover = 5000.0
		cover_sqrt = 70.710678

	var t = n / cover
	var res = (t * t * 0.5 + t * t * t * 0.5) / (t * t) 

	return res * cover_sqrt 


static func linear_interp(a, b, t):
	return a + (b - a) * t

static func radial_interpolate(a, b, t):
	var dot = a.dot(b)
	var res
	
	if dot >= 0:
		res = linear_interp(a, b, t)
	elif dot >= -0.5:
		var half = ((a + b)/2).normalized()
		res = cross(t, linear_interp(a, half, t), linear_interp(half, b, t))
	else:
		var half = b.tangent()
		half = half * (1 if a.dot(half) > 0 else -1)
		res = cross(t, linear_interp(a, half, t), linear_interp(half, b, t))
	
	return res.normalized()

# moving! positive if to the right, negative if to the left of stationary
static func perp_prod(stationary, moving):
	return stationary.dot(moving.tangent())

static func directed_radial_interpolate(a, b, t, dir):
	var dot = a.dot(b)
	var right = perp_prod(a, b) >= 0
	var dir_right = dir > 0
	var res
	dir = -dir
	var seg1
	
	if dir_right == right and dot > -1:
		return radial_interpolate(a, b, t)
	elif dot == -1:
		seg1 = a.tangent() * dir
	else:
		seg1 = -(a + b / 2).normalized()
	
	res = cross(t, radial_interpolate(a, seg1, t), radial_interpolate(seg1, b, t))
	
	return res.normalized()




static func graph(owner, method, size=150, offset=Vector2(), step=0.01):
	var points = PoolVector2Array()
	
	var t = 0
	while t < 1:
		points.append(Vector2(t * size, -owner.call(method, t) * size) + offset)
		t += step
	
	return points

