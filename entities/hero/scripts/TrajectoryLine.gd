extends Line2D

func calculate_trajectory(direction):
	var point_pos = direction * GlobalVariables.trajectory_distance
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, global_position + point_pos)
	
	if result:
		point_pos = result["position"] - global_position
	set_point_position(1,point_pos)


func reset_trajectory():
	set_point_position(1,Vector2.ZERO)
