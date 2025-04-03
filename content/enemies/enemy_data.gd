class_name EnemyData
extends Resource


enum EnemyType {
	WEEVIL,
	SOLDIER,
	TITAN
}

@export var scene: PackedScene
@export var type: EnemyType = EnemyType.WEEVIL
