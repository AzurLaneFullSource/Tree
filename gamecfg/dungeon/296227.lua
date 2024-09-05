return {
	id = 296227,
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
							monsterTemplateID = 296247,
							delay = 0.1,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-43,
								0,
								53
							},
							buffList = {
								200493
							}
						},
						{
							monsterTemplateID = 296232,
							delay = 0.1,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-43,
								0,
								78
							},
							buffList = {
								200493
							}
						},
						{
							monsterTemplateID = 296232,
							delay = 0.1,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-43,
								0,
								28
							},
							buffList = {
								200493
							}
						},
						{
							monsterTemplateID = 295227,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								53
							},
							buffList = {
								201062
							},
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
									switchParam = 4,
									setAI = 70252,
									addWeapon = {
										2978010,
										2978015
									}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 4,
									setAI = 20006,
									addWeapon = {
										2978000,
										2978005,
										2978020
									},
									removeWeapon = {}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 1,
									removeWeapon = {
										2978010,
										2978015
									}
								},
								{
									switchType = 1,
									switchTo = 5,
									index = 4,
									switchParam = 4,
									setAI = 70252,
									addWeapon = {
										2978010,
										2978015
									},
									removeWeapon = {
										2978000,
										2978005,
										2978020
									}
								},
								{
									switchType = 1,
									switchTo = 6,
									index = 5,
									switchParam = 4,
									setAI = 70125,
									addWeapon = {
										2978000,
										2978005,
										2978025
									},
									removeWeapon = {}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 1.5,
									removeWeapon = {
										2978010,
										2978015
									}
								},
								{
									index = 7,
									switchParam = 18,
									switchTo = 8,
									switchType = 1,
									addWeapon = {
										2978030,
										2978035,
										2978040
									},
									removeWeapon = {
										2978000,
										2978005,
										2978025
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 2,
									addWeapon = {
										2978025
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 4,
									addWeapon = {
										2978000,
										2978005
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 2.5,
									removeWeapon = {
										2978000,
										2978005,
										2978025,
										2978030,
										2978035,
										2978040
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 2.5,
									addWeapon = {
										2978045,
										2978055
									}
								},
								{
									switchType = 1,
									switchTo = 13,
									index = 12,
									switchParam = 7,
									setAI = 70252,
									addWeapon = {
										2978050
									}
								},
								{
									index = 13,
									switchType = 1,
									switchTo = 1,
									switchParam = 300,
									addWeapon = {
										2978000,
										2978005
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
