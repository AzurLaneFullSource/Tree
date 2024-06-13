﻿return {
	id = 296223,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 80,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-70,
				20,
				90,
				70
			},
			playerArea = {
				-70,
				20,
				37,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 1,
					key = true,
					waveIndex = 203,
					preWaves = {
						101
					},
					triggerParams = {
						timeout = 0.1
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 295223,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 5.5,
									setAI = 10001,
									addWeapon = {
										2977004
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 2.5,
									addWeapon = {
										2977009
									}
								},
								{
									switchParam = 2,
									switchTo = 4,
									index = 3,
									switchType = 1,
									setAI = 70125
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 2,
									setAI = 70262,
									addWeapon = {
										2977014
									},
									removeWeapon = {
										2977004,
										2977009
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 12,
									addWeapon = {
										2977019,
										2977024
									}
								},
								{
									switchType = 1,
									switchTo = 7,
									index = 6,
									switchParam = 2,
									setAI = 70125,
									removeWeapon = {
										2977014,
										2977019,
										2977024
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 14,
									addWeapon = {
										2977029,
										2977034,
										2977039
									}
								},
								{
									switchType = 1,
									switchTo = 9,
									index = 8,
									switchParam = 2,
									setAI = 10001,
									removeWeapon = {
										2977029,
										2977034,
										2977039
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 8,
									addWeapon = {
										2977044,
										2977049
									}
								},
								{
									switchParam = 3,
									switchTo = 11,
									index = 10,
									switchType = 1,
									setAI = 70125
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 1,
									switchParam = 300,
									addBuff = {
										200958
									},
									addWeapon = {
										2977054,
										2977059,
										2977064,
										2977069
									},
									removeWeapon = {
										2977044,
										2977049
									}
								}
							}
						}
					}
				},
				{
					triggerType = 11,
					waveIndex = 4001,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParams = {
						op = 0,
						key = "warning"
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						203
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {}
}
