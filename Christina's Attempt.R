library(openai)
Sys.setenv(
  OPENAI_API_KEY = ""
)
answer = create_chat_completion(
  model = "gpt-4o-mini",
  temperature = 0,
  messages = list(
    list(
      "role" = "developer",
      "content" = "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous."
    ),
    list(
      "role" = "user",
      "content" = "The following passage that is delimited by XML tags is a comment posted on a nuclear energy development policy. First identify the stance the commenter has on the policy, then explain the commenter's reason for their stance.
      
      <comment>Dear NYSERDA President and CEO Harris:
        The New York Public Interest Research Group (NYPIRG) urges that NYSERDA cease consideration of
      the “Draft Blueprint for Consideration of Advanced Nuclear Technologies” prepared by The Brattle Group
      (the “Draft Nuclear Blueprint”). Instead, NYSERDA should require a review of the Draft Nuclear Blueprint
      by a panel of independent experts, conduct public hearings across the state, it should accurately make public
      the anticipated financial and environmental costs associated with reviewed activities, and identify the
      locations of possible sites of these “Advanced Nuclear” plants.
      The reality of nuclear power has been that it is polluting, dangerous, a security risk, and enormously
      expensive. Moreover, it is a complicated technology that requires significant safety features and one that
      historically has been plagued by construction cost overruns.1
      The Draft Nuclear Blueprint acknowledges
      these concerns but argues that the “Advanced” technology reduces those risks. Supporters of the use of
      nuclear power also acknowledge the risks but argue that those risks are worth it due to the worsening climate
      catastrophe.2
      The Draft Nuclear Blueprint needs more public involvement in order to ensure that all New Yorkers – who
      will bear the costs of the use of this technology – are fully informed of the risks. It was that failure to
      involve the public that led to unnecessary costs and debate over the former Cuomo Administration’s bailout
      of the existing nuclear power plants located in upstate New York, which has been massively costly to New
      York ratepayers. Indeed, that approach should be viewed as the opposite of how the Hochul Administration
      and NYSERDA should behave this time.
      
      Recommendation #1: Have the “Advanced Blueprint” reviewed by an independent panel.
      While we are not in a position to evaluate the underlying analysis prepared by The Brattle Group,3
      it is worth noting that the consulting firm has conducted analyses on behalf of the nuclear industry in the past. New York would be better served if NYSERDA requested an analysis by another respected consultant to
      examine the worthiness of “advanced nuclear technologies,” not one that has had members of the nuclear
      industry as its clients.
      One of the cost justifications made by the former Cuomo Administration was that an “independent” study
      concluded that failure to bail out the upstate plants would lead to a significant electric rate hike. The
      Administration at that time did not release the analysis but many thought it was the one done by The Battle
      Group and paid for by the beneficiary of the bailout, Exelon.5
      
      Recommendation #2: Offer a full statewide schedule of public hearings to react to the “Draft
      Blueprint” and any additional assessments resulting from the independent panel mentioned above.
      The former Cuomo Administration defended its public process on the nuclear subsidies by citing that many
      public hearings were held on the bailout plan. However, those hearings occurred before the summer and
      that the Administration’s last minute near total rewrite of its bailout plan was hatched behind closed doors
      and rammed through within weeks of it being finalized. In fact, the last public hearing occurred weeks
      before the radically changed nuclear subsidy proposal was released on July 8, 2016, which was only two
      weeks before the final deadline for comments on the changed proposal.6 A look at the facts surrounding the state’s last consideration of a major nuclear power proposal clearly demonstrates that the process was
      anything but open. The public deserves better.
      
      
      Recommendation #3: Develop cost estimates based on assumptions that are available to the public.
      The former Cuomo Administration’s bailout plan for the existing upstate nuclear power plants was one
      hatched in secret and only became public after extensive public pressure. In 2017, it was only after the
      release of a cost estimate calculated by the Public Utility Law Project (PULP) that the former
      Administration released its own. PULP’s $7.6 billion estimate of the costs of the subsidy was consistent
      with other studies. It relied on publicly available information. The New York State Assembly then held a
      hearing to examine these costs.7 The former Administration then asserted to lawmakers that the first two
      years were projected to cost $1 billion and then the next ten years will only add up to $1.9 billion.8
      The most recent estimate on the costs to date is that the bailout is a staggering $3.6 billion, with five years
      of subsidies to go.9 It may well turn out that the PULP analysis was spot-on correct. Ratepayers and the
      public at large need to know in advance the full costs of any investment in so called “Advanced Nuclear.”4
      
      Recommendation #4: Identify the likely locations of any proposed nuclear power plant sites.
      The “Draft Blueprint” opaquely states
      “If sited as replacement for fossil-fuel plants that will be closing, it has been suggested that new
      advanced nuclear plants could leverage pre-existing transmission connections…”10
      While the communities in which current fossil-fuel-powered power plants are located have become
      accustomed to the facilities – even if they are suffering from noise and air pollution – they certainly have a
      right to know if their areas would be the location of nuclear power plants and the repository of radioactive
      wastes. It is one thing to deal with traffic and pollution, it is quite another to be a location in which
      radioactive wastes are stored forever. The Draft Nuclear Blueprint drops that idea into the document
      without serious consideration of the need of the public for site-specific information and meaningful input.
      NYPIRG has had a long history of opposing nuclear power as expensive and dangerous. In addition, we
      opposed the former Cuomo Administration’s bailout of existing pants for those reasons as well as the
      secrecy surrounding the plan itself. We strongly urge that NYSERDA restart its consideration of the Draft
      Nuclear Blueprint to allow more scientific and public scrutiny of the proposal. Involving the public will
      lead to a better plan, one that we believe will rely on more assistance to non-nuclear alternatives –
      efficiency, solar, wind, geothermal – to power the state’s fossil-free future.
      
      Sincerely,
      Blair Horner
      Executive Director</comment>
      "
    )
  )
)


first <- answer$choices$message.content
content <- paste("The following text delimited by XML tags is summary on a commenters stance on a nuclear energy development plan. Using this summary, create an edge list based on percieved causal relationships in the comment. 
      <summary>", "</summary>", sep = first)

answer = create_chat_completion(
  model = "gpt-4o-mini",
  temperature = 0,
  messages = list(
    list(
      "role" = "developer",
      "content" = "You are a professional researcher. You are an expert on qualitative content analysis. You are always focused and rigorous."
    ),
    list(
      "role" = "user",
      "content" = content
    )
  )
)

cat(answer$choices$message.content)
