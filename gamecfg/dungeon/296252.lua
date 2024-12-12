return {
	id = 296252,
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
							monsterTemplateID = 295252,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								53
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
									switchParam = 10,
									setAI = 70252,
									addWeapon = {
										2979003,
										2979008
									}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 2,
									setAI = 70188,
									removeWeapon = {
										2979003,
										2979008
									}
								},
								{
									switchType = 1,
									switchTo = 4,
									index = 3,
									switchParam = 15,
									setAI = 70252,
									addWeapon = {
										2979028,
										2979038,
										2979048
									}
								},
								{
									index = 4,
									switchParam = 3,
									switchTo = 5,
									switchType = 1,
									addBuff = {
										201174
									},
									removeWeapon = {
										2979028,
										2979038,
										2979048
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 1,
									addWeapon = {
										2979068,
										2979078
									}
								},
								{
									switchParam = 15,
									switchTo = 7,
									index = 6,
									switchType = 1,
									setAI = 70252
								},
								{
									switchParam = 4,
									switchTo = 8,
									index = 7,
									switchType = 1,
									setAI = 70188,
									addBuff = {
										201174
									},
									removeWeapon = {
										2979068,
										2979078
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 17.5,
									addWeapon = {
										2979098,
										2979103
									}
								},
								{
									index = 9,
									switchParam = 300,
									switchTo = 1,
									switchType = 1,
									addWeapon = {
										2979108
									},
									removeWeapon = {
										2979098,
										2979103
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
