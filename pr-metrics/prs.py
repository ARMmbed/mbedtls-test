#!/usr/bin/python3
# coding: utf-8

"""PR data an misc common functions."""

from datetime import datetime, timedelta
import pickle

with open("pr-data.p", "rb") as f:
    prs = pickle.load(f)


_team_logins = (
    "gilles-peskine-arm",
    "hanno-arm",
    "RonEld",
    "andresag01",
    "mpg",
    "sbutcher-arm",
    "Patater",
    "k-stachowiak",
    "AndrzejKurek",
    "yanesca",
    "mazimkhan",
    "dgreen-arm",
    "artokin",
    "jarlamsa",
    "piotr-now",
    "pjbakker",
    "jarvte",
    "danh-arm",
    "ronald-cron-arm",
    "paul-elliott-arm",
    "gabor-mezei-arm",
    "bensze01",
)


def is_community(pr):
    """Return False if the PR is from a team member or from inside Arm."""
    labels = tuple(l.name for l in pr.labels)
    if "mbed TLS team" in labels or "Arm Contribution" in labels:
        return False
    if pr.user.login in _team_logins:
        return False
    return True


def quarter(date):
    """Return a string decribing this date's quarter, for example 19q3."""
    q = str(date.year % 100)
    q += "q"
    q += str((date.month + 2) // 3)
    return q


_tomorrow = datetime.now().date() + timedelta(days=1)


def pr_dates():
    """Iterate over PRs with open/close dates and community status."""
    for pr in prs:
        beg = pr.created_at.date()
        end = pr.closed_at.date() if pr.closed_at else _tomorrow
        com = is_community(pr)
        cur = not pr.closed_at
        yield (beg, end, com, cur)