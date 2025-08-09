---
title: "Hello World: An introduction to me and my blog"
date: 2025-08-08
draft: false
---

  

# Hello World: An introduction to me and my blog

  

![Hello World](hello-world.jpg)

  

Welcome to NoEngineer.xyz! First off an introduction:
- **Who I am:** I am no engineer. I never studied engineering and I've never worked in the field. I studied biology in school and work professionally as an oceanfront lifeguard. That being said, my passion and most of my free time is spent in engineering.
- **Why the blog:** This site will be my record and portfolio. I will be using it to document each of my projects as I progress. I believe writing out my struggles and successes during each project will only help me in the long run, allowing me to further digest and translate whats in my brain into a cohesive narrative that can be followed along by my future self and anyone else who reads these posts.

## The Blog


I wanted a blogging setup where I could:

- Write on my iPhone during commutes or downtime

- Edit on my Mac when I'm at my desk

- Have everything automatically sync and publish

- Use Markdown (because who wants to fight with rich text editors?)

- Own my content and domain

  

Mission accomplished.

  

## The Technical Stack

  

Here's what I landed on after some experimentation:

  

**Writing & Editing**: Obsidian (syncs between iPhone and Mac via iCloud)

**Version Control**: Git repository on GitHub

**Site Generator**: MkDocs with Material theme

**Hosting**: GitHub Pages

**Domain**: NoEngineer.xyz (because why not?)

**Automation**: Custom fswatch script that monitors file changes

  

## The Magic Workflow

  

The entire publishing process now works like this:

  

1. Write post in Obsidian with `draft: true` in the front matter

2. When ready to publish, change to `draft: false`

3. Save the file

4. fswatch script detects the change within seconds

5. Automatically commits and pushes to GitHub

6. GitHub Actions builds the site with MkDocs

7. Post goes live on NoEngineer.xyz

  

That's it. Write, flip a switch, published.

  

## The Technical Deep Dive

  

The automation runs on a custom bash script using macOS's fswatch utility. It monitors my entire Obsidian vault for file changes, scans for `draft: false` in markdown files, and automatically handles the Git operations. A LaunchAgent keeps it running in the background.

  

The trickiest part was DNS propagation - pointing a custom domain at GitHub Pages means waiting up to 48 hours for DNS servers worldwide to update their caches. But once that was sorted, everything just works.

  

## What's Coming

  

This blog will be a mix of project documentation, technical problem-solving, and the occasional deep dive into why things work the way they do. Some projects already in the pipeline:

  

**Surfboard Repair**: Documenting the process of fixing dings and pressure dents using traditional fiberglass techniques

  

**Knife CAD Modifications**: Redesigning handle geometries and blade profiles for better ergonomics

  

**TV Backlighting Project**: Custom ambient lighting system that responds to on-screen content

  

**Car Lighting Upgrades**: LED conversions and custom accent lighting installation

  

**Star Clock Art Piece**: Kinetic sculpture that tracks celestial movements

  

**Custom Split Keyboard Build**: Designing and building an ergonomic mechanical keyboard from scratch

  

## The Meta Goal

  

Beyond sharing these projects, I want to document the engineering thinking behind everyday problems. How do you approach something you've never done before? What tools make complex tasks manageable? How do you know when "good enough" is actually good enough?

  

Plus, I plan to customize this MkDocs setup extensively - custom themes, interactive elements, maybe even some embedded simulations for the more technical posts.

  

## Testing the System

  

If you're reading this, it means I successfully changed `draft: false`, saved the file, and the entire automation chain worked perfectly. Pretty satisfying for a first post.

  

Let's see where this goes.