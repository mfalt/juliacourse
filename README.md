# juliacourse
A short course in Julia for scientific programming

This version of the julia course is given at the Acoustic Reserach Laboratory @ National University of Singapore. The [original course](https://github.com/mfalt/juliacourse) was given for graduate students at Dept. Automatic Control at Lund University, with course webpage: http://www.control.lth.se/education/doctorate-program/julia-course/julia-course-2019/

Teachers:
[Fredrik Bagge Carlson](http://control.lth.se/staff/fredrik-bagge-carlson/) ([@baggepinnen](https://github.com/baggepinnen))

## Upcoming
Session on Monday 11/11 [Optimization and Learning](https://github.com/baggepinnen/juliacourse/tree/master/lecture6)

It's recommended that you install the following packages before the session
```julia
using Pkg
Pkg.add(PackageSpec(name="Flux",rev="master")) # We will use the latest version of Flux
Pkg.add("IJulia")
Pkg.add("Optim")
Pkg.add("JuMP")
Pkg.add("Zygote")
Pkg.add("ForwardDiff")
Pkg.add("Ipopt")
Pkg.add("GLPK")
Pkg.precompile() # OBS!!! Only run this statement if you do it before the session, it will take a long time to finish.
```

## Lectures
(preliminary schedule)
- [Intro](https://github.com/baggepinnen/juliacourse/blob/master/lecture1/presentation.pdf)
- [Types, functions multiple dispatch](https://github.com/baggepinnen/juliacourse/blob/master/lecture2/presentation.pdf)
- [Performance and profiling](https://github.com/baggepinnen/juliacourse/blob/master/lecture3/performance.pdf)
- [Workflow](https://github.com/baggepinnen/juliacourse/blob/master/lecture4/presentation.pdf)
- [Parallel and distributed computing](https://github.com/baggepinnen/juliacourse/blob/master/lecture5/distributed.pdf)
- [Optimization and Learning](https://github.com/baggepinnen/juliacourse/tree/master/lecture6)
- [ControlSystems.jl](https://github.com/baggepinnen/juliacourse/tree/master/lecture7)



## Previously under upcoming

Session on Thursday 24/10 [Parallel and distributed computing](https://github.com/baggepinnen/juliacourse/blob/master/lecture5/distributed.pdf)

Recommended reading: [Parallel computing in Julia](https://lup.lub.lu.se/search/publication/873af4d5-6229-4ad2-b907-c0ae0f667822)

--------------------------------------------------------------------------------

Session on thursday 17/10 1600 hrs [Workflow](https://github.com/baggepinnen/juliacourse/blob/master/lecture4/presentation.pdf) and [Design patterns and antipatterns](https://github.com/baggepinnen/juliacourse/blob/master/lecture4/presentation_design_patterns.pdf)

Recommended reading: [Modules](https://docs.julialang.org/en/v1/manual/modules/), [Workflow tips](https://docs.julialang.org/en/v1/manual/workflow-tips/)

--------------------------------------------------------------------------------

Session on monday 7/10 1600 hrs [Types, functions multiple dispatch](https://github.com/baggepinnen/juliacourse/blob/master/lecture2/presentation.pdf)

Recommended watching [The Unreasonable Effectiveness of Multiple Dispatch | Stefan Karpinski | JuliaCon 2019](https://www.youtube.com/watch?v=kc9HwsxE1OY)

--------------------------------------------------------------------------------
Session on thursday 3/10 ([Lecture 1: Intro](https://github.com/baggepinnen/juliacourse/blob/master/lecture1/))
Before this session, it would be great if participants have a working Julia installation, and maybe also have given the [getting started](https://docs.julialang.org/en/v1/manual/getting-started/) section of the manual a cursory read. Visit https://julialang.org/ and download Julia v1.2 (or v1.3-rc2 if you want to use the new multi-threading support, I use this version).
If you prefer working in an IDE, I use [Juno](https://junolab.org/) (based on atom), but [vs-code](https://github.com/julia-vscode/julia-vscode), [vim](https://github.com/JuliaEditorSupport/julia-vim) and [emacs](https://github.com/JuliaEditorSupport/julia-emacs) are also well supported.
