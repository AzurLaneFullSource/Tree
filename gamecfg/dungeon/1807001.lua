return {
	map_id = 10001,
	id = 1787001,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
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
					waveIndex = 105,
					preWaves = {},
					triggerParams = {
						timeout = 1
					}
				},
				{
					triggerType = 0,
					waveIndex = 2001,
					conditionType = 1,
					preWaves = {},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16595003,
							delay = 0,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								200761
							}
						}
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
					blockFlags = {
						1
					},
					spawn = {
						{
							monsterTemplateID = 16605502,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {
								200916,
								200767
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
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 13,
									addWeapon = {
										3147101,
										3147102
									}
								},
								{
									index = 2,
									switchParam = 13,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3147103
									},
									removeWeapon = {
										3147101,
										3147102
									}
								},
								{
									index = 3,
									switchParam = 20,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3147104,
										3147105
									},
									removeWeapon = {
										3147103
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 4,
									removeWeapon = {
										3147104
									}
								},
								{
									index = 5,
									switchParam = 2.5,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3147105
									}
								}
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					blockFlags = {
						2
					},
					spawn = {
						{
							monsterTemplateID = 16605501,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {
								200915
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
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 13,
									addWeapon = {
										3147001,
										3147002
									}
								},
								{
									index = 2,
									switchParam = 13,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3147003
									},
									removeWeapon = {
										3147001,
										3147002
									}
								},
								{
									index = 3,
									switchParam = 20,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3147004,
										3147005
									},
									removeWeapon = {
										3147003
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 4,
									removeWeapon = {
										3147004
									}
								},
								{
									index = 5,
									switchParam = 2.5,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3147005
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					conditionType = 1,
					preWaves = {
						101,
						102
					},
					triggerParams = {}
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
				}
			}
		}
	},
	fleet_prefab = {}
}
