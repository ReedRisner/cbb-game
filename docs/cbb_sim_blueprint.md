# College Basketball Coach Simulation Blueprint

This document converts the high-level vision into an implementation-ready architecture for a deep, long-horizon college basketball management simulation.

## 1) Product Pillars

- **Dynasty-first depth**: 50+ year saves must remain coherent and performant.
- **Modern CBB volatility**: NIL + transfer portal + coaching carousel are primary force multipliers.
- **Readable causality**: every major outcome has inspectable drivers (tooltips, logs, model breakdowns).
- **Data + personality hybrid**: ratings determine baseline; personality/morale influence tails.

## 2) Simulation Layers

1. **World layer**: conferences, macroeconomics, policy rules, realignment.
2. **Program layer**: team finances, prestige, staffing, facilities, fan/media climate.
3. **Roster layer**: players, recruits, transfers, NIL deals, eligibility.
4. **Game layer**: possession engine, tactical adjustments, stochastic events.
5. **Narrative layer**: rankings, bracketology, awards, media stories, legacy tracking.

## 3) Core Data Contracts

### Team state vector

`TeamState = [hist_prestige, curr_prestige, facilities, nil_strength, booster_budget, fan_intensity, market_index, coach_staff_score, roster_quality, chemistry]`

### Player state vector

`PlayerState = [physical, skill, tendency, personality, potential_true, potential_visible, morale, academics, injury_profile, nba_interest, eligibility]`

### Season state vector

`SeasonState = [policy_rules, nil_inflation_idx, transfer_rule_mode, conference_map, media_payout_table, tournament_format]`

## 4) Annual Engine Timeline

1. **Policy phase**: apply dynamic rule changes.
2. **Coach carousel**: evaluate hot seats, firings, hires, buyouts.
3. **Roster churn I**: graduations, draft declarations, portal entries.
4. **NIL market opening**: renewals, bids, reallocations.
5. **Recruiting cycle**: scouting, visits, commitments, flips.
6. **Roster churn II**: portal commitments, late entries.
7. **Development camp**: progression/regression, role training.
8. **Schedule generation**: conference + non-con + MTE events.
9. **Season simulation**: game-by-game + weekly rankings.
10. **Postseason**: conference tournaments + NCAA field + champion.
11. **Persistence**: records, awards, history snapshots.

## 5) Program Economy

### Budget formula

`Budget = Base + Tickets + MediaShare + Boosters + NCAAUnits - DebtService - StaffingCosts`

### NIL pool formula

`NILPool = CollectiveStrength * DonorLiquidity * MarketMultiplier * ComplianceMultiplier`

### Prestige dynamics

- `CurrentPrestige[t+1] = 0.82 * CurrentPrestige[t] + 0.18 * SeasonScore - Penalties`
- `HistoricalPrestige[t+1] = 0.97 * HistoricalPrestige[t] + 0.03 * CurrentPrestige[t+1]`

### Anti-snowball controls

- Diminishing returns above 90 prestige.
- Booster fatigue after repeated over-spend without postseason success.
- Depth congestion penalty on elite recruiting conversion.

## 6) Player Model

### Attributes

- **Physical**: speed, strength, burst, stamina, vertical, size profile.
- **Offense**: finishing, shooting splits, handling, passing, post moves.
- **Defense**: point-of-attack, interior, help IQ, rebounding, steal/block.
- **Mental**: consistency, clutch, discipline, leadership.
- **Personality**: loyalty, ego, work ethic, coachability.

### Development equation

`Delta = DevRate * (PotentialTrue - Current) * AgeCurve * MinutesFactor * CoachingDev * MoraleFactor`

### Risk models

- Bust probability increases with high ego + low work ethic + high injury profile.
- Late bloomer probability increases with high work ethic + physical rawness + redshirt path.

## 7) Recruiting System

### Recruit quality

`RecruitScore = 0.45*Current + 0.35*Potential + 0.10*Tools + 0.10*ContextProduction`

### School interest

`Interest = 0.22*MinutesPath + 0.20*Prestige + 0.15*ProPipeline + 0.15*NIL + 0.10*Distance + 0.08*CoachRel + 0.05*Academics + 0.05*StyleFit`

### Commitment choice

`P(commit to s) = softmax(lambda * Interest_s + VisitMomentum + NILSignal - NegativeNews)`

### Fog of war

Observed ratings sampled from normal error around true ratings; variance shrinks via scouting resources and evaluator skill.

## 8) Transfer Portal System

### Portal entry pressure

`TransferPressure = 0.30*MinutesDiss + 0.20*NILGap + 0.15*CoachTrustDrop + 0.10*StyleMisfit + 0.10*TeamLosing + 0.10*AcademicRisk + 0.05*PeerEffect`

Player enters when pressure exceeds a personality-dependent threshold.

### Destination utility

`PortalUtility = 0.28*RoleClarity + 0.22*NILOffer + 0.15*WinningChance + 0.12*CoachFit + 0.10*Location + 0.08*NBAPath + 0.05*Academics`

## 9) Coaching System

### Coach composite

`CoachValue = 0.22*OffIQ + 0.22*DefIQ + 0.18*Recruiting + 0.16*Development + 0.12*Charisma + 0.10*Discipline`

### Hot seat score

`FireRisk = 0.35*Underperform + 0.20*FanUnrest + 0.15*AdminPressure + 0.10*RecruitingDrop + 0.10*Scandal + 0.10*BuyoutFeasible`

### Hire score

`HireScore = 0.30*SystemFit + 0.25*RecruitReach + 0.15*Culture + 0.10*Cost + 0.10*Reputation + 0.10*Upside`

## 10) Tactical Playstyle Layer

- Offensive sliders: pace, rim pressure, post share, PnR rate, 3PA rate, transition.
- Defensive sliders: man/zone ratio, press rate, switch frequency, help aggression.

### Fit score

`StyleFit = 1 - weighted_mismatch(player_tendency, team_scheme)`

Low fit affects efficiency, morale, and transfer pressure.

## 11) Possession Simulation Engine

### Pre-game

- Compute adjusted offense/defense from talent, fit, morale, coaching, rest, injuries, and venue.
- Sample referee profile (tightness/home lean) and tempo noise.

### Possession event tree

1. Transition vs half-court decision.
2. Action call from scheme + tendencies.
3. Branch into turnover/foul/shot.
4. If shot: quality -> make/miss (+and-1 possibility).
5. If miss: rebound contest -> continuation.

### Core equations

- `ShotQuality = Shooter + Creation + Spacing + Playcall - Defender - Contest - Fatigue`
- `P(TOV) = Base + Pressure + HandleMismatch + Fatigue + Crowd - Composure`
- `P(Foul) = Base + DriveRate + Aggression + RefTightness`
- `P(OREB) = sigmoid(OREBedge + Positioning + Hustle - LeakOutPenalty)`

### Late game

Clutch trait, timeout quality, foul strategy logic, and intentional tempo control are applied when margin <= 6 in final 4:00.

## 12) Scheduling and Resume

### Conference scheduling

Constraint optimizer preserving:
- rivalry locks,
- home/away alternation,
- travel burden caps,
- TV inventory windows.

### SOS

`SOS = 0.60*OppQuality + 0.25*OppOppQuality + 0.15*LocationDifficulty`

### Resume

`Resume = 0.30*Q1Wins + 0.20*Q2Wins + 0.15*InverseBadLoss + 0.15*SOS + 0.10*RoadWins + 0.10*Momentum`

## 13) Rankings, Bracketology, and Selection

- AP and Coaches polls generated by voter-agent models with recency and reputation bias.
- NET-like rating combines efficiency and game results with location adjustments.
- Selection committee uses weighted resume + metric profile + injury availability context.
- Seeding via S-curve with bracketing constraints (conference rematch spacing, geography).

## 14) Long-Horizon Dynasty Systems

- Era snapshots every season and decade.
- Persistent records: team, conference, national, coach, player.
- Legacy score drives jersey retirement and Hall of Fame.
- Macro-events: conference collapse, expansion, TV contract shocks, policy shifts.

### Legacy score

`Legacy = 0.30*Production + 0.25*TeamSuccess + 0.20*Awards + 0.15*Efficiency + 0.10*IconMoments`

## 15) AI Coach Behavior Engine

- Personality archetypes: conservative, aggressive, recruiter, portal-raider, developer.
- AI planning stack:
  1. set goals (wins/dev/rebuild),
  2. allocate budget and scouting points,
  3. execute recruiting board,
  4. tune lineups and schemes,
  5. adapt in-game.

### Lineup objective

`LineupScore = Talent + Fit + Stamina + DevelopmentPriority + MoraleStability`

## 16) Event and Narrative Layer

- Weekly media cycle creates sentiment modifiers affecting fan intensity and recruit perception.
- Optional events: scandals, tampering reports, booster demands, rivalry spikes.
- Narrative effects are bounded so flavor does not dominate core simulation math.

## 17) Performance and Determinism

- Deterministic seed per league + season + game for reproducibility.
- Parallel simulation by game-day batches.
- Store derived stats by season snapshots; recompute only on demand for heavy analytics.

## 18) Tuning Targets

- Top-10 teams win rate vs field: ~78–88% (regular season).
- Single-elim upset rates calibrated to historical round-by-round bands.
- Annual transfer entry rate target: 20–35% of scholarship players (era-dependent).
- Recruiting class hit-rate by stars tuned to avoid certainty.

## 19) Ship Plan (Milestones)

1. **M1**: data model + season loop + basic game sim.
2. **M2**: recruiting + portal + NIL + coach carousel.
3. **M3**: rankings/bracketology/postseason + records.
4. **M4**: long-term macro events + narrative engine.
5. **M5**: balancing tools, telemetry dashboards, mod support.

