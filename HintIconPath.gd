extends Path2D

@onready var cpu_particles_2d = $PathFollow2D/CPUParticles2D

func emitParticle(value):
	cpu_particles_2d.emitting = value
