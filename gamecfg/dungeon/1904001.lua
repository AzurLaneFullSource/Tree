return {
	map_id = 10001,
	id = 1904001,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
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
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					blockFlags = {
						201315
					},
					spawn = {
						{
							monsterTemplateID = 16713003,
							delay = 0,
							corrdinate = {
								-8,
								0,
								76
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713003,
							delay = 0,
							corrdinate = {
								-8,
								0,
								28
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								0,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								0,
								0,
								44
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713002,
							delay = 0,
							corrdinate = {
								-12,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713006,
							delay = 1,
							corrdinate = {
								30,
								0,
								52
							},
							buffList = {
								8001,
								8002
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 0,
					preWaves = {
						100,
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								-5,
								0,
								76
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								-5,
								0,
								28
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713002,
							delay = 0,
							corrdinate = {
								5,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713002,
							delay = 0,
							corrdinate = {
								5,
								0,
								42
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713004,
							delay = 0,
							corrdinate = {
								-5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					airFighter = {
						{
							interval = 8,
							onceNumber = 3,
							formation = 10006,
							delay = 0,
							templateID = 3258068,
							totalNumber = 12,
							weaponID = {
								1001079
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 0,
					preWaves = {
						102
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16713003,
							delay = 0,
							corrdinate = {
								-5,
								0,
								76
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713003,
							delay = 0,
							corrdinate = {
								-5,
								0,
								28
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								5,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713001,
							delay = 0,
							corrdinate = {
								5,
								0,
								42
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713005,
							delay = 0,
							corrdinate = {
								-5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713006,
							delay = 1,
							corrdinate = {
								30,
								0,
								66
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16713006,
							delay = 1,
							corrdinate = {
								30,
								0,
								38
							},
							buffList = {
								8001,
								8002
							}
						}
					},
					airFighter = {
						{
							interval = 8,
							onceNumber = 3,
							formation = 10006,
							delay = 0,
							templateID = 3258073,
							totalNumber = 12,
							weaponID = {
								1001084,
								1001089
							},
							attr = {
								airPower = 40,
								maxHP = 15,
								attackRating = 23
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						103
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16713004,
							delay = 0,
							corrdinate = {
								-10,
								0,
								38
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713005,
							reinforceDelay = 6,
							delay = 0,
							corrdinate = {
								-10,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16713002,
							delay = 0,
							corrdinate = {
								-5,
								0,
								76
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713002,
							delay = 0,
							corrdinate = {
								-5,
								0,
								28
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16713006,
							delay = 1,
							corrdinate = {
								30,
								0,
								66
							},
							buffList = {
								8001,
								8002
							}
						},
						{
							monsterTemplateID = 16713006,
							delay = 1,
							corrdinate = {
								30,
								0,
								38
							},
							buffList = {
								8001,
								8002
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 105,
					conditionType = 1,
					preWaves = {
						104
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16713102,
							delay = 0,
							sickness = 0.5,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 50,
								icon = ""
							},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 0.8,
									setAI = 70267,
									addWeapon = {}
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 3,
									addWeapon = {
										3254001
									}
								},
								{
									index = 2,
									switchParam = 2,
									switchTo = 3,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3254001
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 3,
									addWeapon = {
										3254002
									}
								},
								{
									index = 4,
									switchParam = 2,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3254002
									}
								}
							}
						},
						{
							monsterTemplateID = 16713101,
							delay = 0,
							sickness = 0.5,
							corrdinate = {
								10,
								0,
								50
							},
							bossData = {
								hpBarNum = 50,
								icon = ""
							},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 0.8,
									setAI = 70268,
									addWeapon = {}
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 3,
									addWeapon = {
										3254002
									}
								},
								{
									index = 2,
									switchParam = 2,
									switchTo = 3,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3254002
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 3,
									addWeapon = {
										3254001
									}
								},
								{
									index = 4,
									switchParam = 2,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3254001
									}
								}
							}
						}
					}
				},
				{
					triggerType = 5,
					waveIndex = 400,
					preWaves = {
						105
					},
					triggerParams = {
						bgm = "story-hospital-light"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 106,
					conditionType = 1,
					preWaves = {
						105
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16713103,
							delay = 1,
							sickness = 0.5,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 0.8,
									addWeapon = {}
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 3,
									setAI = 70252,
									addWeapon = {
										3254104,
										3254105
									}
								},
								{
									index = 2,
									switchParam = 6,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3254106
									},
									removeWeapon = {
										3254104,
										3254105
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
									index = 4,
									switchParam = 2,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3254107
									},
									removeWeapon = {
										3254106
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 6.2,
									addWeapon = {
										3254108
									}
								},
								{
									index = 6,
									switchParam = 12,
									switchTo = 7,
									switchType = 1,
									addWeapon = {
										3254109,
										3254110,
										3254111
									},
									removeWeapon = {
										3254107,
										3254108
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 2,
									removeWeapon = {
										3254109,
										3254110,
										3254111
									}
								},
								{
									switchType = 1,
									switchTo = 9,
									index = 8,
									switchParam = 2,
									setAI = 70252,
									addWeapon = {
										3254112,
										3254113
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 3.5,
									addWeapon = {
										3254114
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 10,
									addWeapon = {
										3254115
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 4,
									removeWeapon = {
										3254114
									}
								},
								{
									switchType = 1,
									switchTo = 1,
									index = 12,
									switchParam = 2,
									setAI = 70125,
									removeWeapon = {
										3254112,
										3254113,
										3254115
									}
								}
							}
						}
					}
				},
				{
					triggerType = 0,
					waveIndex = 2001,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					blockFlags = {
						201316
					},
					spawn = {},
					reinforcement = {
						{
							monsterTemplateID = 16713007,
							delay = 8,
							corrdinate = {
								5,
								0,
								38
							},
							buffList = {
								8001
							},
							phase = {
								{
									switchParam = 20,
									dive = "STATE_RAID",
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 80000
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 1,
									switchParam = 180
								}
							}
						},
						{
							monsterTemplateID = 16713007,
							delay = 8,
							corrdinate = {
								5,
								0,
								58
							},
							buffList = {
								8001
							},
							phase = {
								{
									switchParam = 20,
									dive = "STATE_RAID",
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 80000
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 1,
									switchParam = 180
								}
							}
						},
						reinforceDuration = 180
					}
				},
				{
					triggerType = 0,
					waveIndex = 3001,
					conditionType = 1,
					preWaves = {
						100
					},
					blockFlags = {
						201327
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16714003,
							delay = 6,
							corrdinate = {
								-10,
								0,
								56
							},
							buffList = {},
							phase = {
								{
									index = 0,
									switchType = 1,
									switchTo = 1,
									switchParam = 0.5
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 20,
									addWeapon = {
										3258113
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3258113
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						106
					},
					triggerParams = {}
				}
			}
		}
	},
	fleet_prefab = {}
}
