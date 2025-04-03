class_name PodStaminaModifier
extends PodModifier


@export var modifier: int = 0
@export var set_to_full: bool = true


func apply(pod: Pod) -> void:
	modify_stamina(pod, modifier)


func unapply(pod: Pod) -> void:
	modify_stamina(pod, -modifier)


func modify_stamina(pod: Pod, amount: int) -> void:
	var dash_pod := pod as DashPod
	var sprint_ability := dash_pod.sprint_ability as SprintAbility
	sprint_ability.max_stamina += amount
	if set_to_full:
		sprint_ability.stamina = sprint_ability.max_stamina
