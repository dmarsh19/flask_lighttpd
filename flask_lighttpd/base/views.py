"""
"""
from flask import render_template

from . import base


@base.route('/')
def main():
    return render_template('base.html')
