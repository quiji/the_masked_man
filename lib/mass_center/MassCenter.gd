
extends Polygon2D

class_name MassCenter

func _ready():

	generate_planes()

	Console.add_command("debug_normals", self, "debug_normals", "Show normals from center of mass nodes")
	




#########################################
# helper methods
#########################################


# moving! positive if to the right, negative if to the left of stationary
static func perp_prod(stationary, moving):
	return stationary.dot(moving.tangent())


########################################################################
# Some Plane magic!


# Debug vars!!
var current_planes = null
var valid_planes = null
var __gravity = Vector2()
var __pos = Vector2()
var __result = -1
var __closest = Vector2()
var __plane2_dot = Vector2()
var __plane1_dot = Vector2()

# Precalculated planes for fast normal generation
var planes = []

func generate_planes():
	planes = []
	var j = 0
	while j < polygon.size():
		var prev = j - 1 if j > 0 else polygon.size() - 1
		var current = j
		# Polygon MUST be created clockwise!!!!
		var vect = polygon[prev] - polygon[current]
		var length = vect.length()
		var normal = -vect.normalized().tangent()
		var distance = normal.dot(polygon[current])
		planes.push_back({n = normal, d = distance, p1 = prev, p2 = current, ls = length * length, l = length})
		j += 1


func dist_to_plane(plane_idx, pos):
	return planes[plane_idx].n.dot(pos) - planes[plane_idx].d

func plane_normal(plane_idx):
	return planes[plane_idx].n
	
func pos_in_plane(plane_idx, pos):
	return pos + dist_to_plane(plane_idx, pos) * -plane_normal(plane_idx)

func get_closest_point_to_pos(plane_idx, pos):
	var p = pos_in_plane(plane_idx, pos)
	var a = get_p1(plane_idx)
	var b = get_p2(plane_idx)
	
	if (a - p).length_squared() < (b - p).length_squared():
		return a
	else:
		return b

func get_p1(plane_idx):
	return polygon[planes[plane_idx].p1]
	
func get_p2(plane_idx):
	return polygon[planes[plane_idx].p2]

func get_plane_length_squared(plane_idx):
	return planes[plane_idx].ls

func is_point_between_plane_points(plane_idx, pos):
	var c = pos_in_plane(plane_idx, pos)
	var a = get_p1(plane_idx)
	var b = get_p2(plane_idx)
	var d = (c - a).length_squared() + (b - c).length_squared()

	return d - get_plane_length_squared(plane_idx) <= 0.00001

func is_vect_between_planes(plane1, plane2, vect):
	var pos = perp_prod(plane_normal(plane1), vect)
	var neg = perp_prod(plane_normal(plane2), vect)


	return pos > 0 and neg < 0

func get_common_point(plane1, plane2, pos):
	
	if planes[plane1].p2 == planes[plane2].p1:
		return polygon[planes[plane1].p2]
	else:
		return polygon[planes[plane1].p1]

func find_common_planes(planes_indexes, pos):
	var closest = null
	var length = null
	var plane_1 = null
	var plane_2 = null
	var j = 0
	while j < planes_indexes.size():
		var p = get_closest_point_to_pos(planes_indexes[j], pos)
		var l = (pos - p).length_squared()
		if closest == null or l <= length:
			if plane_1 == null or l < length:
				plane_1 = planes_indexes[j]
				__plane1_dot = p
			elif l == length:
				plane_2 = planes_indexes[j]
				j = planes_indexes.size()
				__plane2_dot = p
			closest = p
			length = l
		j += 1
	return {p1 = plane_1, p2 = plane_2, clst = closest}

#func calc_concave_planes(concave_list, pos):
	

func get_polygonal_gravity(pos):

	var pos_normal = pos.normalized()
	var gravity = -pos_normal

	current_planes = []
	valid_planes = []
	var i = 0

	while i < planes.size():
		if dist_to_plane(i, pos) > 0:
			if is_point_between_plane_points(i, pos):
				valid_planes.push_back(i)
			else:
				current_planes.push_back(i)
		i += 1
		
	if valid_planes.size() == 1:
		#Console.add_log("mode", "direct")
		gravity = -plane_normal(valid_planes[0])
		__result = valid_planes[0]
		"""
		elif valid_planes.size() > 1:
			Console.add_log("mode", "multiple_concave")
			gravity = (-pos).normalized()
		"""
	elif current_planes.size() == 1:
		#Console.add_log("mode", "weird_case")
		__result = current_planes[0]
		__closest = get_closest_point_to_pos(current_planes[0], pos)
		gravity = (__closest - pos).normalized()
	else:
		#Console.add_log("mode", "multiple_convex")

		var result = find_common_planes(current_planes, pos)
		if result.p2 != null:
			var a = (pos_in_plane(result.p1, pos) - result.clst).length()
			var b = (pos_in_plane(result.p2, pos) - result.clst).length()
			var length = a + b
			var t = a / length
			__closest = result.clst
			gravity = -Smoothstep.cross(t, plane_normal(result.p1), plane_normal(result.p2)).normalized()
		else:
			#Console.add_log("mode", "super_weird_convex_case")
			__result = result.p1
			__closest = result.clst
			gravity = (__closest - pos).normalized()

	if debug:
		__pos = pos
		__gravity = gravity
		update()
	
	return gravity

#########################################
# Outside API method
#########################################

func get_gravity(pos):
	pos = pos - get_position()
	
	if polygon.size() > 0:
		return get_polygonal_gravity(pos)
	else:
		return -pos.normalized()
	
func get_poly_normals(rotation):
	var i = 0
	var normals = []
	while i < planes.size():
		normals.push_back(plane_normal(i))
		i += 1
	return normals

#########################
# DEBUG!
var debug = false

func debug_normals(args):
	debug = not debug
	update()

func _draw():
	

	if debug and polygon.size() > 0 :
	
		var i = 0
		while i < planes.size():
			var middle = ((polygon[planes[i].p1] + polygon[planes[i].p2]) / 2)
			var start = middle 
			draw_line(start, start + planes[i].n * 40, Color(1.0, 0, 0), 4)
			i += 1


		if current_planes != null:
			i = 0
			while i < current_planes.size():
				var j = current_planes[i]
				var middle = ((polygon[planes[j].p1] + polygon[planes[j].p2]) / 2)
				var start = middle 
				draw_line(start, start + planes[j].n * 40, Color(0, 0, 1.0), 4)
				draw_circle(pos_in_plane(j, __pos), 10, Color(0.2, 1.0, 0.2))
	
				i += 1
		if valid_planes != null:
			i = 0
			while i < valid_planes.size():
				var j = valid_planes[i]
				var middle = ((polygon[planes[j].p1] + polygon[planes[j].p2]) / 2)
				var start = middle 
				draw_line(start, start + planes[j].n * 40, Color(0, 0, 1.0), 4)
				draw_circle(pos_in_plane(j, __pos), 10, Color(0.2, 1.0, 0.2))
	
				i += 1


				
		if __result > -1:
			var middle = ((polygon[planes[__result].p1] + polygon[planes[__result].p2]) / 2)
			var start = middle 
			draw_line(start, start + planes[__result].n * 40, Color(0, 0, 1.0), 4)
			draw_circle(pos_in_plane(__result, __pos), 10, Color(0.2, 1.0, 0.2))
				
	
		draw_circle(__closest, 10, Color(0, 0, 0))
		draw_circle(__plane2_dot, 10, Color(0, 0, 0.5))
		draw_circle(__plane1_dot, 10, Color(0, 0.5, 0))
	
		draw_circle(-__pos.normalized() * 100, 10, Color(0, 0, 0.5))
		draw_circle(-__pos.tangent().normalized() * 100, 10, Color(0, 0, 0.5))
		draw_circle(__pos.tangent().normalized() * 100, 10, Color(0, 0, 0.5))
	
		draw_line(__pos, __pos + __gravity * 200, Color(0, 0, 0), 4)

	elif debug:
		draw_circle(Vector2(), 10, Color(0, 0, 0))

